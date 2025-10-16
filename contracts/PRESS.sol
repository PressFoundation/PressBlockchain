// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title PRESS Token
 * @notice Simple ERC20 used for staking/voting/fees in Press Blockchain.
 */
contract PRESS is ERC20, Ownable {
    constructor(address owner_) ERC20("Press Token", "PRESS") Ownable(owner_) {
        _mint(owner_, 1000000000 * 1e18);
    }

    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }
}
