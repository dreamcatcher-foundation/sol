// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IExtension {
    function selectors() external returns (bytes4[] memory);
}