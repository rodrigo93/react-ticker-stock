# frozen_string_literal: true

class PolygonService
  include HTTParty
  base_uri 'https://api.polygon.io/v2'

  def self.fetch_stock_data(ticker)
    options = { query: { apiKey: ENV['API_POLYGON_KEY'] } }
    cache_key = "stock_data/#{ticker}"

    Rails.cache.fetch(cache_key, expires_in: 12.hours) do
      get("/aggs/ticker/#{ticker}/range/1/day/2023-01-01/2023-12-31", options)
    end
  end

  # O number - The open price for the symbol in the given time period.
  # H number - The highest price for the symbol in the given time period.
  # L number - The lowest price for the symbol in the given time period.
  # C number - The close price for the symbol in the given time period.
  # V number - The trading volume of the symbol in the given time period.
  # VW number - The volume weighted average price.
  # T integer - The Unix Msec timestamp for the start of the aggregate window.
  # N number - The number of items in the aggregate window.
  def self.parse_results(results)
    results.map do |item|
      {
        open_price: item['o'],
        high_price: item['h'],
        low_price: item['l'],
        close_price: item['c'],
        volume: item['v'],
        vw_price: item['vw'],
        timestamp: item['t'],
        items_count: item['n']
      }
    end
  end
end
