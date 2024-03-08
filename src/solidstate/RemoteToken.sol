// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import '../../imports/openzeppelin/token/ERC20/ERC20.sol';
import '../../imports/openzeppelin/token/ERC20/extensions/ERC20Burnable.sol';
import '../../imports/openzeppelin/token/ERC20/extensions/ERC20Snapshot.sol';
import '../../imports/openzeppelin/token/ERC20/extensions/ERC20Permit.sol';
import '../../imports/openzeppelin/token/ERC20/extensions/IERC20Metadata.sol';
import '../../imports/openzeppelin/token/ERC20/extensions/IERC20Permit.sol';
import '../../imports/openzeppelin/token/ERC20/IERC20.sol';
import '../../imports/openzeppelin/access/Ownable.sol';

contract RemoteToken is ERC20, ERC20Burnable, ERC20Snapshot, ERC20Permit, Ownable {
    constructor(string memory name, string memory symbol) ERC20(name, symbol) ERC20Permit(name) Ownable(msg.sender) {}

    function mint(address account, uint256 amount) public returns (bool) {
        _checkOwner();
        _mint(account, amount);
    }

    function burn(address account, uint256 amount) public returns (bool) {
        _checkOwner();
        _burn(account, amount);
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal override(ERC20, ERC20Snapshot) {
        super._beforeTokenTransfer(from, to, amount);
    }
}