// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ERC721_NFT is ERC721, Ownable {
    uint256 private tokenIdCounter;
    mapping(address => uint256) private mintedCount;
    address[] private firstFiveMinters;
    address public myCombinedContract;

    constructor() ERC721("CreateProtocol_NFTs", "CP721") {
        tokenIdCounter = 0;
    }

    function mint(address to) external {
        //require(msg.sender == myCombinedContract, "Only MyCombinedContract can mint");
        // require(mintedCount[to] == 0, "Already minted ERC721 token");

        uint256 tokenId = tokenIdCounter;
        _mint(to, tokenId);
        tokenIdCounter++;

        if (tokenIdCounter <= 5) {
            firstFiveMinters.push(to);
        }

        mintedCount[to] = tokenIdCounter;
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

    function setMyCombinedContract(
        address _myCombinedContract
    ) external onlyOwner {
        myCombinedContract = _myCombinedContract;
    }

    function getMintedCount(address wallet) external view returns (uint256) {
        return mintedCount[wallet];
    }
}
