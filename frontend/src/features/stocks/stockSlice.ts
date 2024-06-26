import { createSlice, createAsyncThunk, PayloadAction } from '@reduxjs/toolkit';
import axios from 'axios';

interface StockData {
  price_average?: number;
  price_max?: number;
  price_min?: number;
  volume_average?: number;
  volume_max?: number;
  volume_min?: number;
}

interface StockState {
  data: StockData;
  status: 'idle' | 'loading' | 'succeeded' | 'failed';
  error: string | null;
}

const initialState: StockState = {
  data: {},
  status: 'idle',
  error: null,
};

export const fetchStockData = createAsyncThunk('stock/fetchStockData', async (ticker: string) => {
  const response = await axios.get(`http://localhost:3000/stocks/fetch?ticker=${ticker}`);
  return response.data;
});

const stockSlice = createSlice({
  name: 'stock',
  initialState,
  reducers: {},
  extraReducers: (builder) => {
    builder
      .addCase(fetchStockData.pending, (state) => {
        state.status = 'loading';
      })
      .addCase(fetchStockData.fulfilled, (state, action: PayloadAction<StockData>) => {
        state.status = 'succeeded';
        state.data = action.payload;
      })
      .addCase(fetchStockData.rejected, (state, action) => {
        state.status = 'failed';
        state.error = action.error.message || 'Something went wrong';
      });
  },
});

export default stockSlice.reducer;
