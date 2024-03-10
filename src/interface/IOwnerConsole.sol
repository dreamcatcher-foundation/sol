// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import './IConsole.sol';

interface IOwnerConsole is IConsole {
    function addMemberTo(string memory role, address account) external returns (bool);
    function removeMemberFrom(string memory role, address account) external returns (bool);
    function mint(address account, uint256 amount) external returns (bool);
    function burn(address account, uint256 amount) external returns (bool);
}