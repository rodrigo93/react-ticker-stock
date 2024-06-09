# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PolygonService, type: :model do
  describe '.fetch_stock_data' do
    subject { described_class.fetch_stock_data(ticker) }

    let(:ticker) { 'AAPL' }
    let(:api_url) { "https://api.polygon.io/v2/aggs/ticker/#{ticker}/range/1/day/2023-01-01/2023-12-31" }
    let(:cache_key) { "stock_data/#{ticker}" }
    let(:response_body) do
      {
        'ticker' => 'AAPL',
        'queryCount' => 250,
        'resultsCount' => 250,
        'adjusted' => true,
        'results' =>
          [
            { 'v' => 112_117_471.0,
              'vw' => 125.725,
              'o' => 130.28,
              'c' => 125.07,
              'h' => 130.9,
              'l' => 124.17,
              't' => 1_672_722_000_000,
              'n' => 1_021_065 }
          ]
      }.to_json
    end

    let(:memory_store) { ActiveSupport::Cache.lookup_store :memory_store }

    before do
      allow(Rails).to receive(:cache).and_return(memory_store)
      Rails.cache.clear

      stub_request(:get, api_url)
        .with(query: { apiKey: ENV['API_POLYGON_KEY'] })
        .to_return(status: 200, body: response_body)
    end

    context 'when the API returns a successful response' do
      before { Rails.cache.write(cache_key, response_body) }

      it 'returns the cached API response' do
        expect(JSON.parse(subject)).to eq JSON.parse(response_body)
      end

      it 'does not make a new API call if cache exists' do
        expect(described_class).not_to receive(:get)

        subject
      end
    end

    context 'when the cache does not exist' do
      before { Rails.cache.delete(cache_key) }

      it 'makes a new API call' do
        expect(described_class).to receive(:get)

        subject
      end
    end
  end

  describe '.parse_results' do
    subject { described_class.parse_results(results) }

    context 'when the results are present' do
      let(:results) do
        [
          {
            'o' => 130.28,
            'h' => 130.9,
            'l' => 124.17,
            'c' => 125.07,
            'v' => 112_117_471.0,
            'vw' => 125.725,
            't' => 1_672_722_000_000,
            'n' => 1_021_065
          }
        ]
      end

      it 'returns parsed results' do
        expect(subject).to eq([
                                {
                                  open_price: 130.28,
                                  high_price: 130.9,
                                  low_price: 124.17,
                                  close_price: 125.07,
                                  volume: 112_117_471.0,
                                  vw_price: 125.725,
                                  timestamp: 1_672_722_000_000,
                                  items_count: 1_021_065
                                }
                              ])
      end
    end

    context 'when the results are empty' do
      let(:results) { [] }

      it 'returns an empty array' do
        expect(subject).to eq([])
      end
    end

    context 'when the results are nil' do
      let(:results) { nil }

      it 'raises a NoMethodError' do
        expect { subject }.to raise_error(NoMethodError)
      end
    end
  end
end
