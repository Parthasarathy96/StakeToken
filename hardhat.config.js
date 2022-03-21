require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-ethers");

const URL = "https://eth-rinkeby.alchemyapi.io/v2/Btr94MtiAJQl0xhB6ktaQ_S75TG1ENy1";
const private_key = "PRIVATE_KEY"


module.exports = {
  networks: {
    rinkeby: {
      url: URL,
      accounts: [`0x${private_key}`]
    }
  },
  solidity: "0.8.4",
};
