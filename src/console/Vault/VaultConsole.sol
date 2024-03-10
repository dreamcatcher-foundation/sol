// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import '../../slot/market/PaletteSlot.sol';
import '../../slot/market/MarketSlot.sol';
import '../../slot/asset/TokenSlot.sol';
import '../../library/FinanceLib.sol';
import '../../interface/IToken.sol';

contract VaultConsole is MarketSlot, PaletteSlot {
    using MarketSlotLib for MarketSlotLib.Market;
    using PaletteSlotLib for PaletteSlotLib.Palette;
    using TokenSlotLib for TokenSlotLib.Token;

    function selectors() external view returns (bytes4[] memory response) {
        response = bytes4[](6);
        response[0] = bytes4(keccak256('totalValue()'));
        response[1] = bytes4(keccak256('totalValuePerShare()'));
        response[2] = bytes4(keccak256('amountToMint(uint256)'));
        response[3] = bytes4(keccak256('amountToSend(uint256)'));
        response[4] = bytes4(keccak256('deposit(uint256)'));
        response[5] = bytes4(keccak256('withdraw(uint256)'));
        return response;
    }

    /**
    * NOTE The total value in the denominator held by tokens in the
    *      palette and the denominator itself.
    *
     */
    function totaValue() external view returns (uint256 r18) {
        return FinanceLib.totalValue(palette(), market());
    }

    /**
    * NOTE The share value.
    *
     */
    function totalValuePerShare() external view returns (uint256 r18) {
        return FinanceLib.totalValuePerShare(palette(), market(), token());
    }

    /**
    * NOTE The optimal amount of tokens received if an amount of the 
    *      denominator is sent.
    *
     */
    function amountToMint(uint256 amountInR18) external view returns (uint256 r18) {
        return FinanceLib.amountToMint(palette(), market(), token(), amountInR18);
    }

    /**
    * NOTE The optimal amount of the denominator received when the amount
    *      of tokens is sent.
    *
     */
    function amountToSend(uint256 amountInR18) external view returns (uint256 r18) {
        return FinanceLib.amountToSend(palette(), market(), token(), amountInR18);
    }

    function deposit(uint256 amountIn) external returns (bool) {
        IToken(market.denominator()).transferFrom(msg.sender, address(this), amountIn);
        uint256 amountToMint = FinanceLib.amountToMint(palette(), market(), token(), amountIn);
        token().mint(msg.sender, amountToMint());
        return true;
    }

    function withdraw(uint256 amountIn) external returns (bool) {
        uint256 portion = (amountIn / token.totalSupply()) * 10000;
        for (uint256 i = 0; i < palette().tokensLength(); i++) {
            address token = palette().tokens()[i];
            uint256 amountSold = (IToken(token).balanceOf(address(this)) / 10000) * portion;
            uint256 amount = market().sell(token, amountSold);
            IToken(market.denominator()).transfer(msg.sender, amount);
        }
        return true;
    }
}