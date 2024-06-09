# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StocksController, type: :controller do
  let(:api_service) { PolygonService }

  describe 'GET #fetch' do
    subject { get :fetch, params: { ticker: } }

    let(:ticker) { 'AAPL' }
    let(:results) do
      [
        { 'v' => 112_117_471.0, 'vw' => 125.725, 'o' => 130.28, 'c' => 125.07, 'h' => 130.9, 'l' => 124.17,
          't' => 1_672_722_000_000, 'n' => 1_021_065 },
        { 'v' => 89_100_633.0, 'vw' => 126.6464, 'o' => 126.89, 'c' => 126.36, 'h' => 128.6557, 'l' => 125.08,
          't' => 1_672_808_400_000, 'n' => 770_042 },
        { 'v' => 80_716_808.0, 'vw' => 126.0883, 'o' => 127.13, 'c' => 125.02, 'h' => 127.77, 'l' => 124.76,
          't' => 1_672_894_800_000, 'n' => 665_458 }
      ]
    end

    before do
      allow(api_service).to receive(:fetch_stock_data).with(ticker).and_return(api_response)
    end

    context 'when the API returns a successful response' do
      let(:api_response) do
        instance_double(
          HTTParty::Response,
          success?: true,
          parsed_response: {
            'results' => results
          }
        )
      end

      it 'returns a successful response' do
        subject

        expect(response).to have_http_status(:success)
      end

      it 'returns the processed data' do
        subject

        expected_data = {
          'price_average' => 125.48333333333333,
          'price_max' => 130.9,
          'price_min' => 124.17,
          'volume_average' => 93_978_304.0,
          'volume_max' => 112_117_471.0,
          'volume_min' => 80_716_808.0
        }

        expect(JSON.parse(response.body)).to eq(expected_data)
      end
    end

    context 'when the API returns an error response' do
      let(:api_response) { instance_double(HTTParty::Response, success?: false) }

      it 'returns a bad request status' do
        subject

        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'before_action #sanitize_ticker' do
    subject { get :fetch, params: { ticker: } }

    context 'when ticker is valid' do
      let(:ticker) { 'aapl ' }

      before { allow(api_service).to receive(:fetch_stock_data).with('AAPL') }

      it 'sanitizes the ticker' do
        subject

        expect(controller.params[:ticker]).to eq('AAPL')
      end
    end

    context 'when ticker is invalid' do
      let(:ticker) { 'invalid ticker' }

      it 'returns a bad request status with proper error' do
        subject

        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)).to eq({ 'error' => 'Invalid ticker symbol' })
      end
    end

    context 'when ticker is missing' do
      let(:ticker) { nil }

      it 'returns a bad request status with proper message' do
        subject

        expect(response).to have_http_status(:bad_request)
        expect(JSON.parse(response.body)).to eq({ 'error' => 'Ticker symbol is missing' })
      end
    end
  end
end
