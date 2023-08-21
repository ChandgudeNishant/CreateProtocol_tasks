// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ERC20_Token is ERC20, Ownable {
    uint256 private constant MAX_ERC20_SUPPLY = 1000 * (10 ** 18); // 1000 tokens with 18 decimals

    constructor() ERC20("CreateProtocol_Token", "CP20") {
        _mint(msg.sender, MAX_ERC20_SUPPLY);
    }
}
