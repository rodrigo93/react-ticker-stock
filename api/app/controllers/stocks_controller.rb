# frozen_string_literal: true

class StocksController < ApplicationController
  before_action :sanitize_ticker, only: [:fetch]

  def fetch
    response = api_service.fetch_stock_data(params[:ticker])

    if response.success?
      parsed_results = api_service.parse_results(response.parsed_response['results'])

      render json: calculate_results(parsed_results)
    else
      render json: { error: 'Failed to fetch data' }, status: :bad_request
    end
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  private

  def api_service
    PolygonService
  end

  # rubocop:disable Metrics/AbcSize
  def calculate_results(results)
    {
      price_average: results.sum { |d| d[:close_price] } / results.size,
      price_max: results.max_by { |d| d[:high_price] }[:high_price],
      price_min: results.min_by { |d| d[:low_price] }[:low_price],
      volume_average: results.sum { |d| d[:volume] } / results.size,
      volume_max: results.max_by { |d| d[:volume] }[:volume],
      volume_min: results.min_by { |d| d[:volume] }[:volume]
    }
  end
  # rubocop:enable Metrics/AbcSize

  def sanitize_ticker
    if params[:ticker].present?
      params[:ticker].upcase!
      params[:ticker].strip!

      render json: { error: 'Invalid ticker symbol' }, status: :bad_request unless params[:ticker] =~ /^[A-Z]{1,5}$/
    else
      render json: { error: 'Ticker symbol is missing' }, status: :bad_request
    end
  end
end
