import React, { useState, FormEvent } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { RootState, AppDispatch } from './store';
import { fetchStockData } from './stockSlice';

const App: React.FC = () => {
  const [ticker, setTicker] = useState<string>('');
  const dispatch: AppDispatch = useDispatch();
  const stock = useSelector((state: RootState) => state.stock);

  const handleSubmit = (e: FormEvent) => {
    e.preventDefault();
    dispatch(fetchStockData(ticker));
  };

  return (
    <div className="App">
      <form onSubmit={handleSubmit}>
        <input
          type="text"
          value={ticker}
          onChange={(e) => setTicker(e.target.value)}
          placeholder="Enter stock ticker"
        />
        <button type="submit">Fetch Stock Data</button>
      </form>
      {stock.status === 'loading' && <p>Loading...</p>}
      {stock.status === 'succeeded' && (
        <div>
          <p>Average Price: {stock.data.average_price}</p>
          <p>Max Volume: {stock.data.max_volume}</p>
          <p>Min Volume: {stock.data.min_volume}</p>
          <p>Max Price: {stock.data.max_price}</p>
          <p>Min Price: {stock.data.min_price}</p>
        </div>
      )}
      {stock.status === 'failed' && <p>{stock.error}</p>}
    </div>
  );
};

export default App;
