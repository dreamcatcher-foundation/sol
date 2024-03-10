// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import '../../slot/auth/AuthSlot.sol';
import '../../slot/asset/TokenSlot.sol';
import '../../slot/market/MarketSlot.sol';
import '../../interface/IToken.sol';

contract ClaimConsole is AuthSlot, TokenSlot, MarketSlot {
    using AuthSlotLib for AuthSlotLib.Auth;
    using TokenSlotLib for TokenSlotLib.Token;
    using MarketSlotLib for MarketSlotLib.Market;

    function selectors() external returns (bytes4[] memory response) {
        response = bytes4[](1);
        response[0] = bytes4(keccak256('claimOwnership(string,string)'));
        return response;
    }

    /**
    * Polygon Quickswap
    *    UniswapV2Factory    => 0x5757371414417b8C6CAad45bAeF941aBc7d3Ab32
    *    UniswapV2Router02   => 0xa5E0829CaCEd8fFDD4De3c43696c57F7D7A678ff
    *    WMATIC              => 0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270
    *
     */
    function claimOwnership(string memory name, string memory symbol, uint256 amountIn) external returns (bool) {
        require(amountIn != 0, 'ClaimConsole: the amount in must not be zero for operations');
        auth().claimOwnership();
        token()
            .setName(name)
            .setSymbol(symbol);
        market()
            .setName('quickswap')
            .setFactory(0x5757371414417b8C6CAad45bAeF941aBc7d3Ab32)
            .setRouter(0xa5E0829CaCEd8fFDD4De3c43696c57F7D7A678ff)
            .setDenominator(0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270);
        IToken(market.denominator()).transferFrom(msg.sender, address(this), amountIn);
        token.mint(address(this), 1000000_000000000000000000);
        return true;
    }
}