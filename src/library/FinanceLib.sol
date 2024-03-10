// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import '../slot/market/MarketSlot.sol';
import '../slot/market/PaletteSlot.sol';
import '../slot/asset/TokenSlot.sol';
import '../interface/IToken.sol';
import './VaultLibrary.sol';

library FinanceLib {
    using MarketSlotLib for MarketSlotLib.Market;
    using PaletteSlotLib for PaletteSlotLib.Palette;
    using TokenSlotLib for TokenSlotLib.Token;

    function totalValue(PaletteSlotLib.Palette storage palette, MarketSlotLib.Market storage market) internal view returns (uint256 r18) {
        for (uint256 i = 0; i < palette.maximumTokensLength(); i++) {
            address token = palette.tokens()[i];
            uint256 amount = IToken(token).balanceOf(address(this));
            uint256 price = market.price(token);
            r18 += amount * price;
        }
        r18 += IToken(market.denominator()).balanceOf(address(this));
        return r18;
    }

    function totalValuePerShare(PaletteSlotLib.Palette storage palette, MarketSlotLib.Market storage market, TokenSlotLib.Token storage token) internal view returns (uint256 r18) {
        return totalValue(palette, market) / token.totalSupply();
    }

    function amountToMint(PaletteSlotLib.Palette storage palette, MarketSlotLib.Market storage market, TokenSlotLib.Token storage token, uint256 valueInR18) internal view returns (uint256 r18) {
        return VaultLibrary.amountToMint(valueInR18, totalValue(palette, market), token.totalSupply());
    }

    function amountToSend(PaletteSlotLib.Palette storage palette, MarketSlotLib.Market storage market, TokenSlotLib.Token storage token, uint256 amountInR18) internal view returns (uint256 r18) {
        return VaultLibrary.amountToSend(amountInR18, totalValue(palette, market), token.totalSupply());
    }
}