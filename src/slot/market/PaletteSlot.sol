// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import '../../non-native/openzeppelin/utils/structs/EnumerableSet.sol';

/**
* NOTE Supporting an infinite amount of tokens is not possible because
*      every token must have their value, price, and other operations
*      calculated for them. The token palette allows us to enforce a
*      selected number of tokens that can be supported, this number
*      is low enough that it will not cause a operation to be
*      unaffordable.
*
 */
library PaletteSlotLib {
    using EnumerableSet for EnumerableSet.AddressSet;

    event AddedTokenToPalette(address token);
    event RemovedTokenFromPalette(address token);

    struct Palette {
        EnumerableSet.AddressSet __tokens;
    }

    function maximumTokensLength() internal pure returns (uint256) {
        return 32;
    }

    function requireTokenInPalette(Palette storage palette, address token) internal view returns (Palette storage) {
        require(hasToken(palette, token), 'Palette: is not a token on the palette');
        return palette;
    }

    function requireTokensLengthWillBeWithinRange(Palette storage palette) internal view returns (Palette storage) {
        require(tokensLength(palette) < maximumTokensLength(), 'Palette: cannot support any more tokens');
        return palette;
    }

    function tokens(Palette storage palette) internal view returns (address[] memory) {
        return palette.__tokens.values();
    }

    function tokensLength(Palette storage palette) internal view returns (uint256) {
        return palette.__tokens.length();
    }

    function hasToken(Palette storage palette, address token) internal view returns (bool) {
        return palette.__tokens.contains(token);
    }

    function addToken(Palette storage palette, address token) internal returns (Palette storage) {
        requireTokensLengthWillBeWithinRange(palette);
        palette.__tokens.add(token);
        emit AddedTokenToPalette(token);
        return palette;
    }

    /**
    * NOTE If a token still has a balance in the vault and it is removed
    *      this function will not check. Separate logic must be built to
    *      handle this scenario.
    *
     */
    function removeToken(Palette storage palette, address token) internal returns (Palette storage) {
        palette.__tokens.remove(token);
        emit RemovedTokenFromPalette(token);
        return palette;
    }
}

contract PaletteSlot {
    bytes32 constant internal PALETTE = bytes32(uint256(keccak256('eip1967.PALETTE')) - 1);

    function palette() internal pure returns (PaletteSlotLib.Palette storage sl) {
        bytes32 location = PALETTE;
        assembly {
            sl.slot := location
        }
    }
}