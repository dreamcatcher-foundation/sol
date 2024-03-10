// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import './IConsole.sol';

interface IClaimConsole is IConsole {
    function claimOwnership(string memory name, string memory symbol, uint256 amountIn) external returns (bool);
}