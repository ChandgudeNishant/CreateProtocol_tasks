// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./ERC20_Token.sol";
import "./ERC721_NFT.sol";

contract MyCombinedContract is Ownable {
    ERC20_Token private erc20_X;
    ERC721_NFT private erc721_Y;

    uint256 private constant CLAIM_PERCENTAGE = 5;
    uint256 private totalClaimed;
    uint256 private constant MAX_ERC20_SUPPLY = 1000 * (10 ** 18); // 1000 tokens with 18 decimals

    constructor() {
        erc20_X = new ERC20_Token();
        erc721_Y = new ERC721_NFT();
    }

    function claimTokens() external {
        require(!hasClaimed[msg.sender], "Already claimed");
        require(
            erc721_Y.isFromFirstFiveMinters(msg.sender),
            "Not eligible for claiming"
        );

        uint256 erc20AmountToClaim = (MAX_ERC20_SUPPLY * CLAIM_PERCENTAGE) /
            100 /
            5;
        require(erc20AmountToClaim > 0, "No more tokens to claim");

        if (totalClaimed + erc20AmountToClaim > MAX_ERC20_SUPPLY) {
            erc20AmountToClaim = MAX_ERC20_SUPPLY - totalClaimed;
        }

        erc20_X.transfer(msg.sender, erc20AmountToClaim);

        hasClaimed[msg.sender] = true;
        totalClaimed += erc20AmountToClaim;
    }

    function mintAAA(address to) external onlyOwner {
        erc721_Y.mint(to);
    }

    function totalQQQSupply() external view returns (uint256) {
        return erc20_X.totalSupply();
    }

    function totalAAASupply() external view returns (uint256) {
        return erc721_Y.totalERC721Supply();
    }

    function getFirstFiveMintersData()
        external
        view
        returns (address[] memory, uint256[] memory)
    {
        address[] memory minters = erc721_Y.getFirstFiveMinters();
        uint256[] memory mintedCounts = new uint256[](minters.length);

        for (uint256 i = 0; i < minters.length; i++) {
            mintedCounts[i] = erc721_Y.getMintedCount(minters[i]);
        }

        return (minters, mintedCounts);
    }

    function isAddressInArray(
        address[] memory addresses,
        address target
    ) internal pure returns (bool) {
        for (uint256 i = 0; i < addresses.length; i++) {
            if (addresses[i] == target) {
                return true;
            }
        }
        return false;
    }

    mapping(address => bool) private hasClaimed;

    function getContractERC20Balance() external view returns (uint256) {
        return erc20_X.balanceOf(address(this));
    }

    function getUserERC20Balance(address user) external view returns (uint256) {
        return erc20_X.balanceOf(user);
    }
}
