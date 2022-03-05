// contracts/GameItem.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

/**
    @title Mint a GameItem to any player address, and store the metadata on-chain as base64 encoded string.
    @dev Mint transaction is stored on merkle tree with a fixed number of leaves. 
*/
contract GameItem is ERC721URIStorage {
    using Strings for uint256;
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIds; // to generate a unique token id for each mint
    Counters.Counter private nMinted; // tracks number of nfts minted
    MerkleTree merkleTree; // to reference to MerkleTree contract

    // Name and symbol definition for ERC721 token
    string public constant NAME = "GameItem";
    string public constant SYMBOL = "ITM";
    uint256 public constant MAX_SUPPLY = 100;
    uint256 public constant PRICE = 0.001 ether;
    uint256 public constant MAX_PER_MINT = 1;

    /*** Events ***/
    event GameItemMinted(uint256 tokenId, string tokenURO);

    /**
        @dev Initialise MerkleTree contract with fixed number of leaves (mints). 
        
    */
    // @param merkleTreeAddr MerkleTree's contract address
    constructor() ERC721(NAME, SYMBOL) {
        merkleTree = new MerkleTree();
    }

    /**
        @dev Mint an NFT to player address, and commit computed hash to merkle tree
        @param player Address to mint NFT to
        @return uint256 Token id of newly minted NFT
    */
    function awardItem(address player) public payable returns (uint256) {
        require(nMinted.current() < MAX_SUPPLY, "NFTs sold out");
        require(msg.value >= PRICE, "Not enough ether to mint NFT");

        // Generate new token id
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();

        // Construct metadata (tokenURI) and store on-chain
        // Mint item to player
        string memory tokenUri = constructTokenURI(newItemId);
        _mint(player, newItemId);
        _setTokenURI(newItemId, tokenUri);

        // Store item to Merkle Tree
        bytes32 hash = computeHash(msg.sender, player, newItemId, tokenUri);
        merkleTree.addItem(hash);
        nMinted.increment();

        emit GameItemMinted(newItemId, tokenUri);

        return newItemId;
    }

    /**
        @dev Get number of NFTs owned by an address
        @param _owner Owner's address
        @return tokenCount Number of NFTs owned by address
    */
    function tokensCountByOwner(address _owner)
        external
        view
        returns (uint256)
    {
        uint256 tokenCount = balanceOf(_owner);
        return tokenCount;
    }

    /**
        @dev Construct metadata (as base64 encoded string to store on-chain) for a token
        @param tokenId Generate metedata for this token id
        @return string Base64 encoded string. May use a base64 decoder on generated string to check data.
    */
    function constructTokenURI(uint256 tokenId)
        internal
        pure
        returns (string memory)
    {
        // encode JSON metadata into bytes
        bytes memory dataURI = abi.encodePacked(
            "{",
            '"name": "Boomerang #',
            tokenId.toString(),
            '", ',
            '"description": "Wooden boomerang"'
            "}"
        );
        // encode JSON metadata (in bytes) into a base64 string for on-chain storage
        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(dataURI)
                )
            );
    }

    /**
        @dev Compute hash for merkle tree
        @param sender Address of minter
        @param receiver Address of mint recipient
        @param tokenId Token id of newly minted token
        @param tokenURI Metadata as base64 encoded string
        @return bytes32 Hash of input params
    */
    function computeHash(
        address sender,
        address receiver,
        uint256 tokenId,
        string memory tokenURI
    ) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked(sender, receiver, tokenId, tokenURI));
    }
}

/**
    @title A fixed size Merkle Tree to store minted GameItems
    @dev Call addItem for every mint. It will auto update the merkle tree.
*/
contract MerkleTree {
    bytes32[] public hashes;
    uint256 public nSlots = 128; // to accommodate 100 mints
    uint256 public nMinted;

    /**
        @dev Set the size of hashes array based on number of leaves (nSlots).
    */
    constructor() {
        hashes = new bytes32[](2 * nSlots - 1);
    }

    /** 
        @dev Add a GameItem to the merkle tree
        @param hash Computed hash of token properties
    */
    function addItem(bytes32 hash) external {
        require(nMinted < nSlots, "Maximum number of mints reached");
        hashes[nMinted++] = hash;
        constructMerkleTree();
    }

    /**
        @dev Update merkle tree when a new GameItem is added
        @notice Overwrite hashes array data instead of deleting and reinserting to save gas
    */
    function constructMerkleTree() internal {
        uint256 n = nSlots;
        uint256 index = nSlots;
        uint256 offset = 0;

        // Eventual array when all nSlots are filled (ie. nSlots=4)
        // Assuming 1, 2, 3, 4 represent hashes of tokens
        // [1, 2, 3, 4, hash(1,2), hash(3,4), hash(1,2) + hash(3,4)]
        while (n > 0) {
            for (uint256 i = 0; i < n - 1; i += 2) {
                // start from index after leaves to construct the parent nodes
                hashes[index++] = (
                    keccak256(
                        abi.encodePacked(
                            hashes[offset + i],
                            hashes[offset + i + 1]
                        )
                    )
                );
            }
            offset += n; // offset by number of nodes on current level
            n = n / 2; // number of nodes on next parent level
        }
    }

    /** 
        @dev Get merkle root. Use to check if merkle root changes after each mint
        @return bytes32 Merkle root hash. 
    */
    function getRoot() public view returns (bytes32) {
        return hashes[hashes.length - 1];
    }
}
