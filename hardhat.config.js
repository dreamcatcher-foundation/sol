require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.19",
  networks: {
    hardhat: {
      forking: {
        url: "https://rpc.tenderly.co/fork/2efc56fc-3dd1-48ba-a042-7d7a024c84be"
      }
    }
  }
};