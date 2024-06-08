import React, { useEffect } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { RootState, AppDispatch } from '../../app/store';
import { fetchStockData } from '../../features/stocks/stockSlice';

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
    <div>
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

export default StockData;
