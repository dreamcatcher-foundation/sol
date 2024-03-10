// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import './IConsole.sol';

interface IVaultConsole is IConsole {
    function totalValue() external view returns (uint256);
    function totalValuePerShare() external view returns (uint256);
    function amountToMint(uint256 amountIn) external view returns (uint256);
    function amountToSend(uint256 amountIn) external view returns (uint256);
    function deposit(uint256 amountIn) external returns (bool);
    function withdraw(uint256 amountIn) external returns (bool);
}