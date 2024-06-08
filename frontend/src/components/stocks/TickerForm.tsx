import React, { useState, FormEvent } from 'react';

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
      <form onSubmit={handleSubmit}>
        <input
          type="text"
          value={ticker}
          onChange={(e) => setTicker(e.target.value)}
          placeholder="Enter stock ticker"
        />
        <button type="submit">Fetch Stock Data</button>
      </form>
      {children}
    </>
  );
};

export default TickerForm;
