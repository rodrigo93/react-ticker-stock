# frozen_string_literal: true

class Polygon
  include HTTParty
  base_uri 'https://api.polygon.io/v2'

  def self.fetch_stock_data(ticker)
    options = { query: { apiKey: ENV['API_POLYGON_KEY'] } }

    get("/aggs/ticker/#{ticker}/range/1/day/2023-01-01/2023-12-31", options)
  end
end
