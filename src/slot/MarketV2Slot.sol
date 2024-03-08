// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import '../../imports/uniswap/interfaces/IUniswapV2Factory.sol';
import '../../imports/uniswap/interfaces/IUniswapV2Router02.sol';
import '../library/PairLibrary.sol';

contract MarketV2Slot {
    using PairLibrary for address[];

    struct MarketV2 {
        string _exchangeName;
        address _uniswapV2Factory;
        address _uniswapV2Router;
    }

    // MEMORY
    bytes32 constant internal MARKET_V2 = bytes32(uint256(keccak256('eip1967.MARKET_V2')));

    function marketV2() internal pure returns (MarketV2 storage sl) {
        bytes32 location = MARKET_V2;
        assembly {
            sl.slot := location
        }
    }

    // EVENTS
    event MarketV2__ExchangeNameChanged(address oldExchangeName, address newExchangeName);
    event MarketV2__UniswapV2FactoryChanged(address oldUniswapV2Factory, address newUniswapV2Factory);
    event MarketV2__UniswapV2RouterChanged(address oldUniswapV2Router, address newUniswapV2Router);
    event MarketV2__Swap(address[] path, uint256 amountInR18, uint256 amountOutR18);

    // PROPERTIES
    function __marketV2__exchangeName() internal view returns (string memory) {
        return marketV2()._exchange;
    }

    function __marketV2__changeExchangeName(string memory newExchangeName) internal returns (bool) {
        __marketV2__beforeExchangeNameChanged(newExchangeName);
        address oldExchangeName = __marketV2__exchangeName();
        marketV2()._exchangeName = newExchangeName;
        emit MarketV2__ExchangeNameChanged(oldExchangeName, newExchangeName);
        __marketV2__afterExchangeNameChanged(newExchangeName);
        return true;
    }

    function __marketV2__uniswapV2Factory() internal view returns (address) {
        return marketV2()._uniswapV2Factory;
    }

    function __marketV2__changeUniswapV2Factory(address newUniswapV2Factory) internal returns (bool) {
        __marketV2__beforeUniswapV2FactoryChanged(newUniswapV2Factory);
        address oldUniswapV2Factory = __marketV2__uniswapV2Factory();
        marketV2()._uniswapV2Factory = newUniswapV2Factory;
        emit MarketV2__UniswapV2FactoryChanged(oldUniswapV2Factory, newUniswapV2Factory);
        __marketV2__afterUniswapV2FactoryChanged(newUniswapV2Factory);
        return true;
    }

    function __marketV2__uniswapV2Router() internal view returns (address) {
        return marketV2()._uniswapV2Router;
    }

    function __marketV2__changeUniswapV2Router(address newUniswapV2Router) internal view returns (bool) {
        __marketV2__beforeUniswapV2RouterChanged(newUniswapV2Router);
        address oldUniswapV2Router = __marketV2__uniswapV2Router();
        marketV2()._uniswapV2Router = newUniswapV2Router;
        emit MarketV2__UniswapV2RouterChanged(oldUniswapV2Router, newUniswapV2Router);
        __marketV2__afterUniswapV2RouterChanged(newUniswapV2Router);
        return true;
    }

    // HOOKS
    function __marketV2__beforeExchangeNameChanged(string memory newExchangeName) internal virtual returns (bool) {
        return true;
    }

    function __marketV2__afterExchangeNameChanged(string memory newExchangeName) internal virtual returns (bool) {
        return true;
    }

    function __marketV2__beforeUniswapV2FactoryChanged(address newUniswapV2Factory) internal virtual returns (bool) {
        return true;
    }

    function __marketV2__afterUniswapV2FactoryChanged(address newUniswapV2Factory) internal virtual returns (bool) {
        return true;
    }

    function __marketV2__beforeUniswapV2RouterChanged(address newUniswapV2Router) internal virtual returns (bool) {
        return true;
    }

    function __marketV2__afterUniswapV2RouterChanged(address newUniswapV2Router) internal virtual returns (bool) {
        return true;
    }

    function __marketV2__beforeSwap(address[] memory path, uint256 amountInR18) internal virtual returns (bool) {
        return true;
    }

    function __marketV2__afterSwap(address[] memory path, uint256 amountInR18, uint256 amountOutR18) internal virtual returns (bool) {
        return true;
    }

    // PRICE FEED
    function __marketV2__price(address[] memory pair) internal view returns (uint256 r18) {
        __marketV2__onlyValidPair(pair);
        return pair.price(__marketV2__uniswapV2Factory(), __marketV2__uniswapV2Router());
    }

    function __marketV2__amountOut(address[] pair) internal view returns (uint256 r18) {
        __marketV2__onlyValidPair(pair);
        return pair.amountOut(__marketV2__uniswapV2Factory(), __marketV2__uniswapV2Router());
    }

    function __marketV2__amountOut(address[] path, uint256 amountInR18) internal view returns (uint256 r18) {
        __marketV2__onlyValidPath(path);
        return path.amountOut(__marketV2__uniswapV2Factory(), __marketV2__uniswapV2Router(), amountInR18);
    }

    // SWAP
    function __marketV2__swap(address[] memory path, uint256 amountInR18) internal returns (uint256 r18) {
        __marketV2__beforeSwap(path, amountInR18);
        __marketV2__onlyValidPath(path);
        uint256 amountOutR18 = path.swap(__marketV2__uniswapV2Factory(), __marketV2__uniswapV2Router(), amountInR18, 200);
        emit MarketV2__Swap(path, amountInR18, amountOutR18);
        __marketV2__afterSwap(path, amountInR18, amountOutR18);
        return amountOutR18;
    }

    // GUARDS
    function __marketV2__onlyValidPair(address[] memory pair) internal view returns (bool) {
        require(pair.length == 2, 'MarketV2Slot: invalid pair');
        return true;
    }

    function __marketV2__onlyValidPath(address[] memory path) internal view returns (bool) {
        require(path.length >= 2, 'MarketV2Slot: invalid path');
        return true;
    }
}