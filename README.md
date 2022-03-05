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
- Deploy MerkleTree.sol (included in GameItem.sol file)
- Copy the MerkleTree contract address and deploy the GameItem.sol contract with a specified number of leaves (ie. 0x0813d4a158d06784FDB48323344896B2B1aa0F85, 4)

# Deploying to Rinkeby Testnet

- Clone this project
- From root directory, run `npm install` to install all dependencies
- To deploy to Rinkeby, run `npx hardhat run scripts/run.js --network rinkeby`. This will execute the run.js script, which will auto deploy the GameItem.sol smart contract and mint an NFT. The contract address will also be shown.

If you choose to deploy to the Rinkeby Testnet, you will be able to test the smart contract (ie. minting an NFT) via a user interface (web app). After deploying to Rinkeby, set up the web app project from https://github.com/violetwee/ERC721_MerkleTree_Frontend.

# Testing on Remix

- From GameItem contract, insert the address to mint item to for "awardItem" field
- Click "awardItem". This should mint tokenId=1
- Input 1 for "ownerOf" field
- Click "ownerOf". You should see the owner's address for tokenId=1

# Resources

- [Remix IDE](https://remix.ethereum.org/#optimize=false&runs=200&evmVersion=null) - Write Solidity contracts straight from the browser
- [ERC721](https://docs.openzeppelin.com/contracts/4.x/erc721) - Constructing an ERC721 Token Contract
- [Base64](https://docs.openzeppelin.com/contracts/4.x/utilities#base64) - On-chain Metadata
- [Merkle Trees](https://www.youtube.com/watch?v=n6nEPaE7KZ8&list=PLO5VPQH6OWdULDcret0S0EYQ7YcKzrigz&index=18) - Merkle Trees Explained
- [Hardhat](https://hardhat.org/) - Ethereum development environment
