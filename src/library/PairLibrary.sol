// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import '../../imports/uniswap/interfaces/IUniswapV2Factory.sol';
import '../../imports/uniswap/interfaces/IUniswapV2Router02.sol';
import '../../imports/uniswap/interfaces/IUniswapV2Pair.sol';
import '../interface/IToken.sol';
import './ConversionLibrary.sol';

library PairLibrary {
    using PairLibrary for address[];
    using ConversionLibrary for uint256;
    
    function token0(address[] memory pair) internal pure returns (address) {
        return pair[0];
    }

    function token1(address[] memory pair) internal pure returns (address) {
        return pair[pair.length - 1];
    }

    function decimals0(address[] memory pair) internal view returns (uint8) {
        return IERC20(pair.token0()).decimals();
    }

    function decimals1(address[] memory pair) internal view returns (uint8) {
        return IERC20(pair.token1()).decimals();
    }

    function toInterface(address[] memory pair, IUniswapV2Factory uniswapV2Factory) internal view returns (IUniswapV2Pair) {
        return IUniswapV2Pair(pair.toAddress(uniswapV2Factory));
    }

    function toAddress(address[] memory pair, IUniswapV2Factory uniswapV2Factory) internal view returns (address) {
        return uniswapV2Factory.getPair(pair.token0(), pair.token1());
    }

    function reserves(address[] memory pair, IUniswapV2Factory uniswapV2Factory) internal view returns (uint256[] memory) {
        uint256[] memory reserve = new uint256[](2);
        (reserve[0], reserve[1],) = pair
            .toInterface(uniswapV2Factory)
            .getReserves();
        return reserve;
    }

    function isZeroAddress(address[] memory pair, IUniswapV2Factory uniswapV2Factory) internal view returns (bool) {
        return pair.toAddress(uniswapV2Factory) == address(0);
    }

    function isSameLayout(address[] memory pair, IUniswapV2Factory uniswapV2Factory) internal view returns (bool) {
        return pair.token0() == pair.toInterface(uniswapV2Factory).token0();
    }

    function price(address[] memory pair, IUniswapV2Factory uniswapV2Factory, IUniswapV2Router02 uniswapV2Router02) internal view returns (uint256 r18) {
        if (pair.isZeroAddress(uniswapV2Factory)) {
            return 0;
        }
        if (pair.isSameLayout(uniswapV2Factory)) {
            return uniswapV2Router02
                .quote(
                    10 ** pair.decimals0(),
                    pair.reserves(uniswapV2Factory),
                    pair.reserves(uniswapV2Factory)
                )
                .fromRToR18(pair.decimals1());
        }
        return uniswapV2Router02
            .quote(
                10 ** pair.decimals1(),
                pair.reserves(uniswapV2Factory),
                pair.reserves(uniswapV2Factory)
            )
            .fromRToR18(pair.decimals1());
    }

    function amountOut(address[] memory pair, IUniswapV2Factory uniswapV2Factory, IUniswapV2Router02 uniswapV2Router02) internal view returns (uint256 r18) {
        if (pair.isZeroAddress(uniswapV2Factory)) {
            return 0;
        }
        if (pair.isSameLayout(uniswapV2Factory)) {
            return uniswapV2Router02
                .getAmountOut(
                    10 ** pair.decimals0(),
                    pair.reserves(uniswapV2Factory),
                    pair.reserves(uniswapV2Factory)
                )
                .fromRToR18(pair.decimals1());
        }
        return uniswapV2Router02
            .getAmountOut(
                10 ** pair.decimals1(),
                pair.reserves(uniswapV2Factory),
                pair.reserves(uniswapV2Factory)
            )
            .fromRToR18(pair.decimals1());
    }

    function amountOut(address[] memory path, IUniswapV2Factory uniswapV2Factory, IUniswapV2Router02 uniswapV2Router02, uint256 r18AmountIn) internal view returns (uint256 r18) {
        uint256[] memory amounts = uniswapV2Router02
            .getAmountsOut(
                r18AmountIn.fromR18ToR(path.decimals0()),
                path
            );
        return amounts[amounts.length - 1]
            .fromRToR18(path.decimals1());
    }

    function minAmountOut(address[] memory path, IUniswapV2Factory uniswapV2Factory, IUniswapV2Router02 uniswapV2Router02, uint256 r18AmountIn, uint8 swapThreshold) internal view returns (uint256 r18) {
        uint256 r18AmountOut = path
            .amountOut(
                uniswapV2Factory, 
                uniswapV2Router02, 
                r18AmountIn);
        uint256 r18AcceptableLoss = ((r18AmountOut
            .fromR18ToR(100) / 10000) * swapThreshold)
            .fromRToR18(100);
        return r18AmountOut - r18AcceptableLoss;
    }

    function swap(address[] memory path, IUniswapV2Factory uniswapV2Factory, IUniswapV2Router02 uniswapV2Router02, uint256 r18AmountIn, uint8 swapThreshold) internal returns (uint256 r18) {
        IERC20 tokenIn = IERC20(path.token0());
        tokenIn
            .approve(address(uniswapV2Router02), 0);
        tokenIn
            .approve(address(uniswapV2Router02), r18AmountIn);
        uint256[] memory amounts = uniswapV2Router02
            .swapExactTokensForTokens(
                r18AmountIn
                    .fromR18ToR(
                        path.decimals0()),
                path
                    .minAmountOut(
                        uniswapV2Factory, 
                        uniswapV2Router02, 
                        r18AmountIn, 
                        swapThreshold),
                path,
                msg.sender,
                block.timestamp
            );
        tokenIn.approve(address(uniswapV2Router02), 0);
        return amounts[amounts.length - 1]
            .fromRToR18(path.decimals1());
    }
}