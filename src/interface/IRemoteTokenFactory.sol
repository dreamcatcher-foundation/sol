// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IRemoteTokenFactory {
    function deploy(string memory name, string memory symbol) external returns (address);
}