# Ticker Stock App 📈

This is a simple stock app that allows users to search for a stock ticker and
view the current price of the stock powered by [Polygon.io](https://polygon.io/).

https://github.com/rodrigo93/react-ticker-stock/assets/9914896/f599b9d7-a85c-4002-8902-154130e4afaa

# Getting Started 🚀

This project is using:

- React v18
- Node v20
- Ruby on Rails v7
- Ruby v3
- RSpec

## Setup 🛠

### Backend / API

1. Navigate to the `api` directory
2. Run `bundle install`
3. Run `rails db:create`
4. Run `rails db:migrate`
5. Run `rails s`
6. Navigate to `http://localhost:3000`

```shell
cd api  
bundle install
rails db:create
rails db:migrate
rails s
```

### Frontend

1. Navigate to the `frontend` directory
2. Run `npm install`
3. Run `npm start`
4. Navigate to `http://localhost:3001`

```shell
cd frontend
npm install
npm start
```

> ⚠️ The frontend will run on port `3001` by default.
To change it, update the `PORT` variable in the `frontend/package.json` file.
