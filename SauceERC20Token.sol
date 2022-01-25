// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./token/ERC20/ERC20Burnable.sol";
import "./token/ERC20/ERC20Capped.sol";
import "./token/ERC20/ERC20Mintable.sol";
import "./token/ERC20/ERC20Permit.sol";
import "./token/ERC1363/ERC1363.sol";
import "./access/Roles.sol";

contract SauceERC20Token is ERC20Capped, ERC20Mintable, ERC20Burnable, ERC20Permit, ERC1363, Roles {
    constructor (
        string memory name,
        string memory symbol,
        uint8 decimals,
        uint256 cap,
        uint256 initialBalance
    )
        ERC1363(name, symbol)
        ERC20Capped(cap)
        ERC20Permit(name)
    {
        _setupDecimals(decimals);
        _mint(_msgSender(), initialBalance);
    }

    /**
     * @dev Function to mint tokens.
     *
     * NOTE: restricting access to addresses with MINTER role. See {ERC20Mintable-mint}.
     *
     * @param account The address that will receive the minted tokens
     * @param amount The amount of tokens to mint
     */
    function _mint(address account, uint256 amount) internal override onlyMinter {
        super._mint(account, amount);
    }

    /**
     * @dev Function to stop minting new tokens.
     *
     * NOTE: restricting access to owner only. See {ERC20Mintable-finishMinting}.
     */
    function _finishMinting() internal override onlyOwner {
        super._finishMinting();
    }

    /**
     * @dev See {ERC20-_beforeTokenTransfer}. See {ERC20Capped-_beforeTokenTransfer}.
     */
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal override(ERC20, ERC20Capped) {
        super._beforeTokenTransfer(from, to, amount);
    }
}