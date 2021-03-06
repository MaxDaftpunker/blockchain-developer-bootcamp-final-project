# **Community  Aggregator**

## Project description

The idea is a website where different crypto communities can register and mint NFTs to distribute or sell to members of their communities (as a way of supporting their activities). 
The NFTs will have a central identity and a section of the visual design that will be affected by the characteristics of each community. 
These NFTs are unique for each community and the amount that each community will be able to mint will depend on a bonding curve that will define the relationship between the order in which a community registers to mint and the supply of a their unique NFT they would be able to mint. 
The idea behind is to reward with scarcer NFTs the communities the register and mint first, the early adopters.

## Public Ethereum Account (NFT certification)

Mainnet: 0xb62241A978D41E35F008B0E165Cf5cBe43e9feEB

## Directory structure

- `client`: Project's React frontend.
- `contracts`: Smart contracts that are deployed in the Ropsten testnet. 
- `migrations`: Migration files for deploying contracts in `contracts` directory.
- `test`: Tests for smart contracts.

## Frontend project

**URL: https://blockchain-developer-bootcamp-final-project.maxdaftpunker.repl.co/**

## How to run this project locally

### Starting the UI locally:

Navigate into the client directory, install the dependencies then run the start script:

- `cd client`
- `npm install`
- `npm run start`
- Open `http://localhost:3000`

Note the UI will currently only connect to the Ropsten testnet. 

### Deploying the smart contract

- `npm install`
- `npm install -g ganache-cli`

### Deploying to a local development network

Start a local development blockchain on port 7545 and deploy the contract:

- `ganache-cli -7545`
- `truffle migrate --network development`
- `truffle console --network development`
-  Run tests in Truffle console: `test`

### Deploying to the ropsten or rinkeby testnets

Create a .env file in the projects root directory and add the following:

- Your metamask seed mneumonic (MNEMONIC)
- Infura URL including API key (INFURA_URL)

Deploy the contract:

- `truffle migrate --network rinkeby --reset`

  or

- `truffle migrate --network ropsten --reset`

Important: If you are redeploying the contract will be given a new address. This will need to be updated to App.js (line 12).

### Environment variables:

-MNEMONIC=

-INFURA_URL=

## Simple workflow

**Important: To be able to mint NFTs or add an account to the whitelist, you must be the owner. 
So you must deploy the contract with your account or be whitelisted so you can mint**

1. Enter service web site
2. Connect your metamask
3. Mint some Nfts (as the owner) or whitelist an account (address)
4. Mint some Nfts with the new account
5. Each time you mint, the amount of Nfts will increment by the bonding curve.

Note: Ideally the `whitelistUser` and `removeWhitelistUser` functions should not be on the front end, but for testing purposes they were placed so that they can be interacted with.

## Screencast link

https://www.loom.com/share/121fc07d5e3f4e73ab4879f057d8092d

**Note that "testnets.opensea.io" was not working properly at the time the video was recorded.**

## TODO

- Implement the ERC1155 standard
- Implement a generative NFT and allow the community "owner" to imput a the name of the communitie on the Nft.
