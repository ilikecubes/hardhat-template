// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// ERC20 Mock Token, where Name == Symbol & Owner receives 10_000_000 ether worth of tokens
contract ERC20Mock is ERC20, Ownable {
    constructor(string memory name) ERC20(name, name) {
        _mint(_msgSender(), 10_000_000 ether);
    }
}
