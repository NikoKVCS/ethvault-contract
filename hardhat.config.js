require("@nomicfoundation/hardhat-toolbox");

// The next line is part of the sample project, you don't need it in your
// project. It imports a Hardhat task definition, that can be used for
// testing the frontend.
require("./tasks/faucet");
const fs = require("fs");
const privateKey = fs.readFileSync(".privateKey", "utf8");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  defaultNetwork: "goerli",
  solidity: "0.8.17",
  networks: {
    localhost: {
      url: "http://127.0.0.1:8545/",
      /*
        notice no mnemonic here? it will just use account 0 of the hardhat node to deploy
        (you can put in a mnemonic here to set the deployer locally)

      */
    },
    goerli: {
      url: "https://goerli.infura.io/v3/460f40a260564ac4a4f4b3fffb032dad", // <---- YOUR INFURA ID! (or it won't work)
      accounts: [privateKey],
    },
  },
  etherscan: {
    apiKey: {
      mainnet: "DNXJA8RX2Q3VZ4URQIWP7Z68CJXQZSC6AW",
      goerli: "DNXJA8RX2Q3VZ4URQIWP7Z68CJXQZSC6AW",
      kovan: "DNXJA8RX2Q3VZ4URQIWP7Z68CJXQZSC6AW",
      rinkeby: "DNXJA8RX2Q3VZ4URQIWP7Z68CJXQZSC6AW",
      ropsten: "DNXJA8RX2Q3VZ4URQIWP7Z68CJXQZSC6AW",
      sepolia: "DNXJA8RX2Q3VZ4URQIWP7Z68CJXQZSC6AW",
      // add other network's API key here
    },
  },
};
