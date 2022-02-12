require('@nomiclabs/hardhat-waffle');
require('dotenv').config({path: './.env.local'});

module.exports = {
  solidity: "0.8.0",
  networks: {
    rinkeby: {
      url: `${process.env.ALCHEMY_RINKEBY_URL}`,
      accounts: [`${process.env.RINKEBY_PRIVATE_KEY}`],
    },
    ganache:{
      url: 'http://localhost:7545',
      accounts: [process.env.GANACHE_PRIVATE_KEY]
    }
  }
};