import React, { useState } from 'react';
import Ticker from '../stocks/index';
import './App.css';

const App: React.FC = () => {
  const [ticker, setTicker] = useState<string>('');

  const handleTickerSubmit = (submittedTicker: string) => {
    setTicker(submittedTicker);
  };

  return (
    <div className="app">
      <Ticker.Form onSubmit={handleTickerSubmit} >
        <Ticker.Data ticker={ticker} />
      </Ticker.Form>
    </div>
  );
};

export default App;
