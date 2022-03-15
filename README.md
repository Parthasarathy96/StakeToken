# STAKE COIN

    This project is a basic Staking smart contract use case. If the user stakes a certain amount of token the user is incentivized with a certain percentage of thier stake. 

    15% APR 3 months
    30% Apr 6 months
    45% Apr 9 mnnths


# Built with

    * Solidity
    * Hardhat framework
    * Ether.js

# Getting Started 

    # Prerequisites
        * Node.js 
        * npm
        * MetaMask
    
    # Installation
        * Get Alchemy/Infura Http key(Ropsten) from https://www.alchemy.com/ or https://infura.io/.

        * Clone the repo with link mentioned below

            https://github.com/parthabodhi/API-Task.git

        * Install NPM packages with the following command.

            npm install

        * Enter your Alchemy/Infura key in scripts/Deploy.js into the following variable.

            const url = 'Enter your Alchemy/Infura key'

        * Enter your private key from MetaMask in scripts/Deploy.js into the following variable.

            const private_key = 'Enter your private key from metamask'

        * Enter the below command to compile the solidity code.

            npx hardhat compile

        * Enter the below command to deploy the solidity code to the ropsten testnet.

           npx hardhat run scripts/Deploy.js --network ropsten 


