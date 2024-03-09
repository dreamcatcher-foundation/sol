// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import './RemoteToken.sol';

contract RemoteTokenFactory {
    constructor() {}

    function deploy(string memory name, string memory symbol) public returns (address) {
        RemoteToken newRemoteToken;
        newRemoteToken = new RemoteToken(name, symbol);
        newRemoteToken.transferOwnership(msg.sender);
        return address(newRemoteToken);
    }
}