require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-ethers");

const URL = "https://eth-ropsten.alchemyapi.io/v2/Btr94MtiAJQl0xhB6ktaQ_S75TG1ENy1";
const private_key = "398a44a32ff96418595b79ac234339e059621bd01275a7a6751dbb15bc89a53d"


module.exports = {
  networks: {
    ropsten: {
      url: URL,
      accounts: [`0x${private_key}`]
    }
  },
  solidity: "0.8.4",
};
