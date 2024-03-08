// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import '../../imports/openzeppelin/utils/structs/EnumerableSet.sol';
import '../interface/IToken.sol';

struct TokenPalette {
    EnumerableSet.AddressSet _tokenContracts;
}

library TokenPaletteLibrary {
    using TokenPaletteLibrary for TokenPalette;
    using EnumerableSet for EnumerableSet.AddressSet;

    // PROPERTIES
    function tokenContracts(TokenPalette storage tokenPalette, uint256 tokenContractId) internal view returns (address) {
        return tokenPalette._tokenContracts.at(tokenContractId);
    }

    function tokenContracts(TokenPalette storage tokenPalette) internal view returns (address[] memory) {
        return tokenPalette._tokenContracts.values();
    }

    function numberOfTokenContracts(TokenPalette storage tokenPalette) internal view returns (uint256) {
        return tokenPalette._tokenContracts.length();
    }

    function maximumNumberOfTokenContracts() internal view returns (uint256) {
        return 32;
    }

    function addTokenContract(TokenPalette storage tokenPalette, address tokenContract) internal returns (EnumerableSet.AddressSet storage) {
        require(tokenPalette.numberOfTokenContracts() < tokenPalette.maximumNumberOfTokenContracts(), 'TokenPaletteLibrary: there are too many tokens in this palette');
        tokenPalette._tokenContracts.add(tokenContract);
        return tokenPalette;
    }

    function removeTokenContract(EnumerableSet.AddressSet storage tokenPalette, address tokenContract) internal returns (EnumerableSet.AddressSet storage) {
        require(IToken(tokenContract).balanceOf(address(this)) = 0, 'TokenPaletteLibrary: the balance of this token in this contract must be zero to remove it from the palette');
        tokenPalette._tokenContracts.remove(tokenContract);
        return tokenPalette;
    }
}

contract TokenPaletteSl {
    using TokenPaletteLibrary for TokenPalette;

    bytes32 constant internal TOKEN_PALETTE = bytes32(uint256(keccak256('eip1967.tokenPalette')) - 1);

    function tokenPalette() internal pure returns (TokenPalette storage sl) {
        bytes32 location = TOKEN_PALETTE;
        assembly {
            sl.slot := location
        }
    }   
}