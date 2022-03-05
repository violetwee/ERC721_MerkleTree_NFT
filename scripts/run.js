const { utils } = require("ethers");

async function main() {
  // Get owner/deployer's wallet address
  const [owner] = await hre.ethers.getSigners();

  // Get contract that we want to deploy
  const contractFactory = await hre.ethers.getContractFactory("GameItem");

  // Deploy contract with the correct constructor arguments
  const contract = await contractFactory.deploy();

  // Wait for this transaction to be mined
  await contract.deployed();

  // Get contract address
  console.log("Contract deployed to:", contract.address);

  // Mint an NFT by sending 0.001 ether
  txn = await contract.awardItem(owner.address, { value: utils.parseEther('0.001') });
  await txn.wait()

  console.log('NFT minted');

  // Get all token IDs of the owner
  let count = await contract.tokensCountByOwner(owner.address)
  console.log(`You own ${count} NFT(s).`);

}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });