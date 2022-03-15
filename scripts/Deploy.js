const { ethers } = require("hardhat");
const hre = require("hardhat");

async function main() {
  const deploye = await ethers.getSigner();
  console.log(`deploying contract with account: ${deploye.address}`);

  const balance = await deploye.getBalance();
  console.log(`Account Balance: ${balance.toString()}`);

  const Token = await ethers.getContractFactory('stakeToken');
  const token = await Token.deploy(1000000);
  console.log(`Token Address: ${token.address}`);
}
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
