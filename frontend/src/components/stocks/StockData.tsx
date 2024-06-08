import React, { useEffect } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { RootState, AppDispatch } from '../../app/store';
import { fetchStockData } from '../../features/stocks/stockSlice';
import './StockData.css';

interface StockDataProps {
  ticker: string;
}

const formatCurrency = (value: number | undefined) => {
  return value && value.toLocaleString('en-US', { style: 'currency', currency: 'USD' });
};

const StockData: React.FC<StockDataProps> = ({ ticker }) => {
  const dispatch: AppDispatch = useDispatch();
  const stock = useSelector((state: RootState) => state.stock);

  useEffect(() => {
    if (ticker) {
      dispatch(fetchStockData(ticker));
    }
  }, [ticker, dispatch]);

  return (
    <div className="data-table-container">
      {stock.status === 'succeeded' && (
        <table className="data-table">
          <thead>
            <tr>
              <th>Item</th>
              <th>Maximum</th>
              <th>Minimum</th>
              <th>Average</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>Price</td>
              <td>{formatCurrency(stock.data.price_max)}</td>
              <td>{formatCurrency(stock.data.price_min)}</td>
              <td>{formatCurrency(stock.data.price_average)}</td>
            </tr>
            <tr>
              <td>Volume</td>
              <td>{formatCurrency(stock.data.volume_max)}</td>
              <td>{formatCurrency(stock.data.volume_min)}</td>
              <td>{formatCurrency(stock.data.volume_average)}</td>
            </tr>
          </tbody>
        </table>
      )}
      {stock.status === 'loading' && <div className="loading">Searching...</div>}
      {stock.status === 'failed' && (
        <div className="error-message">
          <h2>📉</h2>
          <p>Couldn't find the requested ticker</p>
        </div>
      )}
    </div>
  );
};

export default StockData;