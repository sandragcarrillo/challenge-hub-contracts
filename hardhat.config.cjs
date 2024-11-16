/** @type import('hardhat/config').HardhatUserConfig */


require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();
require("hardhat-deploy");

module.exports = {
  solidity: "0.8.27",
  networks: {
    zircuit: {
      url: "https://zircuit1-testnet.p2pify.com",
      accounts: [process.env.PRIVATE_KEY]
    },
  },
  etherscan: {
    apiKey: {
      zircuit: process.env.ZIRCUIT_API_KEY,
    },
    customChains: [
      {
        network: 'zircuit',
        chainId: 48899,
        urls: {
          apiURL: 'https://explorer.testnet.zircuit.com/api/contractVerifyHardhat',
          browserURL: 'https://explorer.testnet.zircuit.com/',
        },
      },
    ],
  },
  namedAccounts: {
    deployer: 0, 
  },
};
