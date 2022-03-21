const { ethers } = require("hardhat");
const hre = require("hardhat");

async function main() {
  const deployer = await ethers.getSigner();
  console.log(`deploying contract with account: ${deployer.address}`);

  const balance = await deployer.getBalance();
  console.log(`Account Balance: ${balance.toString()}`);

  const Token = await ethers.getContractFactory('stakeToken');
  const token = await Token.deploy();
  console.log(`Token Address: ${token.address}`);
}
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
