require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

module.exports = {
  solidity: {
    version: "0.8.18",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  networks: {
    mainnet: {
      url: process.env.RPC_URL !== undefined ? process.env.RPC_URL : "",
      chainId: parseInt(
        process.env.CHAIN_ID !== undefined ? process.env.CHAIN_ID : 1
      ),
      accounts:
        process.env.PRIVATE_KEY !== undefined ? [process.env.PRIVATE_KEY] : [],
    },
  },
  etherscan: {
    apiKey:
      process.env.BLOCKCHAIN_EXPLORER_KEY !== undefined
        ? process.env.BLOCKCHAIN_EXPLORER_KEY
        : "",
  },
};
