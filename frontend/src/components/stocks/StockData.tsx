import React, { useEffect } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { RootState, AppDispatch } from '../../app/store';
import { fetchStockData } from '../../features/stocks/stockSlice';
import './StockData.css';

interface StockDataProps {
  ticker: string;
}

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
              <td>{stock.data.max_price}</td>
              <td>{stock.data.min_price}</td>
              <td>{stock.data.average_price}</td>
            </tr>
            <tr>
              <td>Volume</td>
              <td>{stock.data.max_volume}</td>
              <td>{stock.data.min_volume}</td>
              <td>TBD</td>
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