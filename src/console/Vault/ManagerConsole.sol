// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import '../../slot/auth/AuthSlot.sol';
import '../../slot/market/MarketSlot.sol';
import '../../slot/market/PaletteSlot.sol';
import '../../interface/IToken.sol';

contract ManagerConsole is AuthSlot, MarketSlot, PaletteSlot {
    using AuthSlotLib for AuthSlotLib.Auth;
    using MarketSlotLib for MarketSlotLib.Market;
    using PaletteSlotLib for PaletteSlotLib.Palette;

    function selectors() external returns (bytes4[] memory response) {
        response = bytes4[](4);
        response[0] = bytes4(keccak256('buy(address,uint256)'));
        response[1] = bytes4(keccak256('sell(address,uint256)'));
        response[2] = bytes4(keccak256('addTokenToPalette(address)'));
        response[3] = bytes4(keccak256('removeTokenFromPalette(address)'));
        return response;
    }

    function buy(address token, uint256 amountR18) external returns (uint256 r18) {
        auth().requireMembership('managers');
        palette().requireTokenInPalette(token);
        return market().buy(token, amountR18);
    }

    function sell(address token, uint256 amountR18) external returns (uint256 r18) {
        auth().requireMembership('managers');
        return market().sell(token, amountR18);
    }

    function addTokenToPalette(address token) external returns (bool) {
        require(market().price(token) != 0, 'ManagerConsole: cannot add token with a price of zero');
        auth().requireMembership('managers');
        palette().addToken(token);
        return true;
    }

    function removeTokenFromPalette(address token) external returns (bool) {
        require(IToken(token).balanceOf(address(this)) == 0, 'ManagerConsole: cannot remove token with balance');
        auth().requireMembership('managers');
        palette().removeToken(token);
        return true;
    }
}