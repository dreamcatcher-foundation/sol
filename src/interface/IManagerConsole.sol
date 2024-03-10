// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import './IConsole.sol';

interface IManagerConsole is IConsole {
    function buy(address token, uint256 amount) external returns (uint256);
    function sell(address token, uint256 amount) external returns (uint256);
    function addTokenToPalette(address token) external returns (bool);
    function removeTokenFromPalette(address token) external returns (bool);
}