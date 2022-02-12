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
      accounts: ["044d59887f2394de7054e7436e0081f5a6c6fbbf2c88beb5e28334176f0b45c2"]
    }
  }
};