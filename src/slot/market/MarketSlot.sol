// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import '../../non-native/uniswap/interfaces/IUniswapV2Pair.sol';
import '../../non-native/uniswap/interfaces/IUniswapV2Factory.sol';
import '../../non-native/uniswap/interfaces/IUniswapV2Router02.sol';
import '../../library/PairLibrary.sol';
import './PaletteSlot.sol';

/**
* NOTE The market is compatible with the v2 uniswap interface. It is
*      important that during construction the name, factory, and router
*      point to the correct exchange.
*
* NOTE The denominator will determine what pairs can be traded with.
*
* NOTE Supports buy and sell to denominator, routed swaps are not supported.
*
* Constructor Instructions
*
*   1. set name
*   2. set factory
*   3. set router
*   4. set denominator
 */
library MarketSlotLib {
    using PaletteSlotLib for PaletteSlotLib.Palette;

    event ChangedMarketName(string indexed name);
    event ChangedMarketFactory(address indexed factory);
    event ChangedMarketRouter(address indexed router);
    event ChangedMarketDenominator(address indexed denominator);
    event Bought(address indexed token);
    event Sold(address indexed token);

    struct Market {
        string __name;
        address __factory;
        address __router;
        address __denominator;
    }

    function name(Market storage market) internal view returns (string memory) {
        return market.__name;
    }

    /**
    * NOTE UniswapV2Factory
    *
     */
    function factory(Market storage market) internal view returns (address) {
        return market.__factory;
    }

    /**
    * NOTE UniswapV2Router02
    *
     */
    function router(Market storage market) internal view returns (address) {
        return market.__router;
    }

    /**
    * NOTE The denominator is the token contract that the market will exchange
    *      to and from. It is important to pick a denominator that has good
    *      liquidity and support to maximize the amount of pairs available.
    *
     */
    function denominator(Market storage market) internal view returns (address) {
        return market.__denominator;
    }

    function price(Market storage market, address token) internal view returns (uint256 r18) {
        address[] memory pair = address[](2);
        pair[0] = token;
        pair[1] = denominator(market);
        return pair.price(IUniswapV2Factory(factory(market)), IUniswapV2Router02(router(market)));
    }

    function amountOut(Market storage market, address token, uint256 amountR18) internal view returns (uint256 r18) {
        address[] memory pair = address[](2);
        pair[0] = token;
        pair[1] = denominator(market);
        return pair.amountOut(IUniswapV2Factory(factory(market)), IUniswapV2Router02(router(market)), amountR18);
    }

    function setName(Market storage market, string memory name) internal returns (Market storage) {
        market.__name = name;
        emit ChangedMarketName(name);
        return market;
    }

    function setFactory(Market storage market, address factory) internal returns (Market storage) {
        market.__factory = factory;
        emit ChangedMarketFactory(factory);
        return market;
    }

    function setRouter(Market storage market, address router) internal returns (Market storage) {
        market.__router = router;
        emit ChangedMarketRouter(router);
        return market;
    }

    function setDenominator(Market storage market, address denominator) internal returns (Market storage) {
        market.__denominator = denominator;
        emit ChangedMarketDenominator(denominator);
        return market;
    }

    function buy(Market storage market, address token, uint256 amountR18) internal returns (uint256 r18) {
        address[] memory pair = address[](2);
        pair[0] = denominator(market);
        pair[1] = token;
        emit Bought(token);
        return pair.swap(IUniswapV2Factory(factory(market)), IUniswapV2Router02(router(market)), amountR18, 200);
    }

    function sell(Market storage market, address token, uint256 amountR18) internal returns (uint256 r18) {
        address[] memory pair = address[](2);
        pair[0] = token;
        pair[1] = denominator(market);
        emit Sold(token);
        return pair.swap(IUniswapV2Factory(factory(market)), IUniswapV2Router02(router(market)), amountR18, 200);
    }
}

contract MarketSlot {
    bytes32 constant internal MARKET = bytes32(uint256(keccak256('eip1967.MARKET')) - 1);

    function market() internal pure returns (MarketSlotLib.Market storage sl) {
        bytes32 location = MARKET;
        assembly {
            sl.slot := location
        }
    }
}