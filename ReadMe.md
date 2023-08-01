# Foundry Funding Project

Welcome to the Foundry Funding Project! This project features a unique combination of Ethereum's Sepolia test network and the Anvil blockchain simulator in a comprehensive package ideal for both learning and implementing Ethereum-based applications.

## Prerequisites

Before you dive in, ensure you have the following installed:

**Foundry**: A development toolkit for Ethereum, much like a swiss army knife for Ethereum developers. Install Foundry using this command:
cargo install --git https://github.com/gakonst/forge --branch main




**Anvil**: Anvil provides a local environment for simulating a blockchain network and is a fantastic tool for risk-free testing of Ethereum applications. Install Anvil with:
cargo install --git https://github.com/gakonst/anvil --branch main




## Environment Setup  

Create a `.env` file in your project directory and provide the following four variables:

`SEPOLIA_ALCHEMY_RPC`: Your Alchemy RPC URL for the Sepolia testnet.

`SEPOLIO_PRICEFEED_ADDRESS`: The address of the price feed contract on the Sepolia testnet.

`ETHERSCAN_API_KEY`: An API key for Etherscan, a widely used Ethereum explorer.  

`PRIVATE_KEY`: Your Ethereum private key.

Don't forget to replace them with your own values.

## Running the Project

Compile your contracts with:
make build




To run your scripts tests:
make test




Deploy your contracts with:
make deploy ARGS="--network sepolia"




To fund your contract:
make fund ARGS="--network sepolia"




And to withdraw from your contract:
make withdraw ARGS="--network sepolia"




## Additional Commands

Our provided Makefile includes several other commands that make project management easier:
Clean the repository: make clean

Remove unneeded modules: make remove

Install & update dependencies: make install, make update

Create a project snapshot: make snapshot

Format your code: make format

Run blockchain simulation: make anvil




Remember, if you don't specify an argument (ARGS="--network sepolia"), the operations will default to the Anvil local environment.

## About the Developer

This project is the brainchild of an enthusiastic full-stack web developer, a budding blockchain developer, and an AI enthusiast. The developer believes in the future—the undeniable amalgamation of blockchain, cryptocurrencies, Web3, and AI. This combination, the developer believes, is set to revolutionise how we interact with technology and the world around us.

## Resources 

For those eager to learn more about Ethereum development:

- Ethernaut
- Dapp University   
- Solidity Documentation

## Contribution

Everyone is welcome to contribute! Check out the CONTRIBUTING.md for the procedure to submit enhancements or issue reports.

## License  

This project is licensed under the License. Refer to the LICENSE.md file for details. Your contributions—within the license guidelines—are greatly appreciated. Together, we can make this project even better. What are you waiting for? Dive into the world of Ethereum development like never before
Let me know if you would like me to modify the formatting further.

