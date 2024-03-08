// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import './RemoteToken.sol';

contract RemoteTokenFactory {
    constructor() {}

    function deploy(string memory name, string memory symbol) public returns (address) {
        ShareToken newShareToken;
        newShareToken = new ShareToken(name, symbol);
        newShareToken.transferOwnership(msg.sender);
        return address(newShareToken);
    }
}