// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract ERC721_NFT is ERC721, Ownable {
    using SafeMath for uint256;
    uint256 private tokenIdCounter;
    mapping(address => uint256) private mintedCount; // Track the number of tokens minted by each address
    address[] private firstFiveMinters; // Array to store the first five minters' addresses
    uint256[] private tokenIds;
    address public myCombinedContract; // Address of MyCombinedContract

    constructor() ERC721("CreateProtocol_NFTs", "CP721") {
        tokenIdCounter = 0;
    }

    uint256 tokenId;

    function mint(address to) external returns (uint256) {
        //require(msg.sender == myCombinedContract, "Only MyCombinedContract can mint");
        // require(mintedCount[to] == 0, "Already minted ERC721 token");

        tokenId = tokenIdCounter;
        _mint(to, tokenId);
        tokenIdCounter++;

        if (tokenIdCounter <= 5) {
            firstFiveMinters.push(to);
            tokenIds.push(tokenId);
        }

        mintedCount[to] = tokenIdCounter;
        return tokenId; // Return the tokenId
    }

    function totalERC721Supply() external view returns (uint256) {
        return tokenIdCounter;
    }

    function isFromFirstFiveMinters(address wallet) public view returns (bool) {
        return mintedCount[wallet] > 0 && mintedCount[wallet] <= 5;
    }

    function getFirstFiveMinters() external view returns (address[] memory) {
        return firstFiveMinters;
    }

    function getFirstFiveTokenId() external view returns (uint256[] memory) {
        return tokenIds;
    }

    function setMyCombinedContract(
        address _myCombinedContract
    ) external onlyOwner {
        myCombinedContract = _myCombinedContract;
    }

    function getMintedCount(address wallet) external view returns (uint256) {
        return mintedCount[wallet];
    }
}
