# frozen_string_literal: true

class StocksController < ApplicationController
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

  # rubocop:disable Metrics/AbcSize
  def calculate_results(results)
    {
      average_price: results.sum { |d| d[:close_price] } / results.size,
      max_volume: results.max_by { |d| d[:volume] }[:volume],
      min_volume: results.min_by { |d| d[:volume] }[:volume],
      max_price: results.max_by { |d| d[:high_price] }[:high_price],
      min_price: results.min_by { |d| d[:low_price] }[:low_price]
    }
  end
  # rubocop:enable Metrics/AbcSize

  def api_service
    Polygon
  end
end
