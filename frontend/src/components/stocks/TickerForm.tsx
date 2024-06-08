import React, { useState, FormEvent } from 'react';
import './TickerForm.css';

interface TickerFormProps {
  onSubmit: (ticker: string) => void;
  children: React.ReactNode;
}

const TickerForm: React.FC<TickerFormProps> = ({ onSubmit, children }) => {
  const [ticker, setTicker] = useState<string>('');

  const handleSubmit = (e: FormEvent) => {
    e.preventDefault();
    onSubmit(ticker);
  };

  return (
    <>
      <form onSubmit={handleSubmit} className="ticker-form">
        <input
          type="text"
          value={ticker}
          onChange={(e) => setTicker(e.target.value)}
          placeholder="Enter stock ticker"
          className="ticker-input"
        />
        <button type="submit" className="submit-button" disabled={ticker === ''}>
          Search
        </button>
      </form>
      {children}
    </>
  );
};

export default TickerForm;
