// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
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

    mapping(uint256 => bool) private hasClaimed;

    function claimTokens(uint256 _id) external {
        uint256 __id = _id - 1;
        address[] memory FirstFiveAddress = erc721_Y.getFirstFiveMinters();
        require(!hasClaimed[__id], "Already claimed");
        require(
            FirstFiveAddress[__id] == msg.sender,
            "Not eligible for claiming"
        );
        require(__id < FirstFiveAddress.length, "Invalid ID");
        uint256 erc20AmountToClaim = (MAX_ERC20_SUPPLY * CLAIM_PERCENTAGE) /
            100;
        require(erc20AmountToClaim > 0, "No more tokens to claim");

        erc20_X.transfer(msg.sender, erc20AmountToClaim);

        hasClaimed[__id] = true;
        totalClaimed += erc20AmountToClaim;
    }

    function mintY(address to) external onlyOwner {
        erc721_Y.mint(to);
    }

    function total_X_Supply() external view returns (uint256) {
        return erc20_X.totalSupply();
    }

    function total_Y_Supply() external view returns (uint256) {
        return erc721_Y.totalERC721Supply();
    }

    function getFirstFiveMintersData()
        external
        view
        returns (address[] memory, uint256[] memory)
    {
        address[] memory minters = erc721_Y.getFirstFiveMinters();
        uint256[] memory tokens = erc721_Y.getFirstFiveTokenId();
        return (minters, tokens);
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

    function getContractERC20Balance() external view returns (uint256) {
        return erc20_X.balanceOf(address(this));
    }

    function getUserERC20Balance(address user) external view returns (uint256) {
        return erc20_X.balanceOf(user);
    }
}
