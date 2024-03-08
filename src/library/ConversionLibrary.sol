// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
* Decimal Representation
*   example:
*       r10 => 10 decimals
*       r11 => 11 decimals
*       r12 => 12 decimals
*
 */
library ConversionLibrary {
    using ConversionLibrary for uint256;

    /**
    * ? decimals => ? decimals
    *
     */
    function toR(uint256 number, uint8 oldDecimals, uint8 newDecimals) internal pure returns (uint256 r) {
        return number
            .fromRToR18(oldDecimals)
            .fromR18ToR(newDecimals);
    }

    /**
    * 18 decimals => ? decimals
    *
     */
    function fromR18ToR(uint256 number, uint8 oldDecimals) internal pure returns (uint256 r) {
        return ((number * (10 ** 18) / (10 ** 18)) * (10 ** oldDecimals)) / (10 ** 18);
    }

    /**
    * ? decimals => 18 decimals
    *
     */
    function fromRToR18(uint256 number, uint8 oldDecimals) internal pure returns (uint256 r18) {
        return ((number * (10 ** 18) / (10 ** oldDecimals)) * (10 ** 18)) / (10 ** 18);
    }
}