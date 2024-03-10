// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IConsole {
    function selectors() external returns (bytes4[] memory);
}