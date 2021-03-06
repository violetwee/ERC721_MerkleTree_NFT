# ERC721_MerkleTree

This is a simple demo on minting an NFT to any address, with the NFT hash stored on a Merkle Tree.

## Metadata

The NFT's metadata (tokenURI) is constructed in realtime when the mint is performed.
This data is encoded into a base64 string and stored on-chain.

## Merkle Tree

A keccak256 hash is generated based on the NFT's properties and used for the Merkle Tree.
A fixed size merkle tree is used, in order to save gas.

# Deploying smart contracts on Remix

- Copy GameItem.sol to Remix
- Compile GameItem.sol on Remix
- Deploy GameItem.sol on Remix

## Testing on Remix

Each NFT costs 0.001 eth (1000000 gwei) to mint.

- Set value to 1000000 Gwei
- From GameItem deployed contract, paste the address to mint item to for "awardItem" field
- Click "awardItem". This should mint tokenId=1
- Input 1 for "ownerOf" field
- Click "ownerOf". You should see the owner's address for tokenId=1

## Sample Mints

<img src="https://github.com/violetwee/ERC721_MerkleTree_NFT/blob/main/images/mint_token_1.png" width="800px" height="auto"/>

<img src="https://github.com/violetwee/ERC721_MerkleTree_NFT/blob/main/images/mint_token_2.png" width="800px" height="auto"/>

<img src="https://github.com/violetwee/ERC721_MerkleTree_NFT/blob/main/images/mint_token_3.png" width="800px" height="auto"/>

<img src="https://github.com/violetwee/ERC721_MerkleTree_NFT/blob/main/images/mint_token_4.png" width="800px" height="auto"/>

# Deploying to Rinkeby Testnet

## Get an Alchemy API Key

- Register for an account on Alchemy (https://www.alchemy.com/)
- Create a new project
- From project details page, click "View Key". Copy the HTTP URL and paste it on a text editor (temporarily).

## Get your Metamask Private Key (Rinkeby)

- Install and create a wallet on Metamask (https://metamask.io/), if you do not have one yet
- Set the network to "Rinkeby Test Network"
- Click on the 3 small dots and click on "Account Details"
- Click "Export Private Key"
- Copy this key and paste it on a text editor (temporarily)

## Setup and deployment

- Clone this project
- Create a ".env" file on the root directory. Set the following string constants, using the values obtained above:

```
API_URL = <HTTP URL to Alchemy Project>
PRIVATE_KEY = <Private Key to a Metamask account>
```

- From root directory, run `npm install` to install all dependencies
- To deploy to Rinkeby, run `npx hardhat run scripts/run.js --network rinkeby`. This will execute the run.js script, which will auto deploy the GameItem.sol smart contract and mint an NFT. The contract address will also be shown.

<img src="https://github.com/violetwee/ERC721_MerkleTree_NFT/blob/main/images/hardhat_rinkeby.png" width="800px" height="auto"/>

If you choose to deploy to the Rinkeby Testnet, you will be able to test the smart contract (ie. minting an NFT) via a user interface (web app). After deploying to Rinkeby, set up the web app project from https://github.com/violetwee/ERC721_MerkleTree_Frontend.

## Contract Address (Rinkeby)

0x53E0111741076cDF614c48ca8Addde3BC6917BFb

# Resources

- [Remix IDE](https://remix.ethereum.org/#optimize=false&runs=200&evmVersion=null) - Write Solidity contracts straight from the browser
- [ERC721](https://docs.openzeppelin.com/contracts/4.x/erc721) - Constructing an ERC721 Token Contract
- [Base64](https://docs.openzeppelin.com/contracts/4.x/utilities#base64) - On-chain Metadata
- [Merkle Trees](https://www.youtube.com/watch?v=n6nEPaE7KZ8&list=PLO5VPQH6OWdULDcret0S0EYQ7YcKzrigz&index=18) - Merkle Trees Explained
- [Hardhat](https://hardhat.org/) - Ethereum development environment
- [Metamask](https://metamask.io/) - A crypto wallet & gateway to blockchain apps
- [Rinkeby Faucets](https://faucets.chain.link/rinkeby) - Request eth for Rinkeby Testnet
- [Rinkeby Etherscan](https://rinkeby.etherscan.io/) - Rinkeby Testnet block explorer
