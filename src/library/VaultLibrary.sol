// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library VaultLibrary {
    function amountToMint(uint256 valueInR18, uint256 balanceR18, uint256 totalSupplyR18) internal pure returns (uint256 r18) {
        return (valueInR18 * totalSupplyR18) / balanceR18;
    }

    function amountToSend(uint256 amountInR18, uint256 balanceR18, uint256 totalSupplyR18) internal pure returns (uint256 r18) {
        return (amountInR18 * balanceR18) / totalSupplyR18;
    }
}