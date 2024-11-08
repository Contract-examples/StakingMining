// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol";

contract RNT is ERC20, Ownable, ERC20Permit {
    // custom error
    error ExceedsMaxSupply(uint256 maxSupply, uint256 currentSupply, uint256 mintAmount);

    uint256 public constant MAX_SUPPLY = 1_000_000_000 * 10 ** 18; // max supply
    uint256 public immutable INITIAL_SUPPLY = 1_000_000 * 10 ** 18; // initial supply

    constructor() ERC20("RNT", "RNT") Ownable(msg.sender) ERC20Permit("RNT") {
        _mint(msg.sender, INITIAL_SUPPLY);
    }

    function mint(address to, uint256 amount) external onlyOwner {
        if (totalSupply() + amount > MAX_SUPPLY) {
            revert ExceedsMaxSupply(MAX_SUPPLY, totalSupply(), amount);
        }
        _mint(to, amount);
    }

    // get remaining mintable supply
    function remainingMintableSupply() public view returns (uint256) {
        return MAX_SUPPLY - totalSupply();
    }
}
