// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./PairLibrary.sol";
import "./ConversionLibrary.sol";
import "./MarketV2Slot.sol";

library AssetLibrary {
    using AssetLibrary for address;
    using PairLibrary for address[];
    using ConversionLibrary for uint256;
    using MarketV2GetterAndSetterLibrary for MarketV2;

    function token(address token) internal view returns (IERC20) {
        return IERC20(token);}

    /**
    * token => denominator
     */
    function toPair(address token, MarketV2 marketV2) internal view returns (address[] memory) {
        address[] memory pair = new address[](2);
        pair[0] = token;
        pair[1] = address(marketV2.denominatorToken());
        return pair;}
    
    /**
    * denominator => token
     */
    function toReversePair(address token, MarketV2 marketV2) internal view returns (address[] memory) {
        address[] memory pair = new address[](2);
        pair[0] = address(marketV2.denominatorToken());
        pair[1] = token;
        return pair;}

    /**
    * token => ... => denominator
     */
    function toPath(address token, MarketV2 marketV2, IERC20[] memory routes) internal view returns (address[] memory) {
        address[] memory path = new address[](routes.length + 3);
        path[0] = token;
        for (uint256 i = 0; i < routes.length; i++) {
            path[i] = address(routes[i - 1]);}
        path[path.length - 1] = address(marketV2.denominatorToken());
        return path;}
    
    /**
    * denominator => ... => token
     */
    function toReversePath(address token, MarketV2 marketV2, IERC20[] memory routes) internal view returns (address[] memory) {
        address[] memory path = new address[](routes.length + 3);
        path[0] = address(marketV2.denominatorToken());
        for (uint256 i = 0; i < routes.length; i++) {
            path[i] = address(routes[i - 1]);}
        path[path.length - 1] = token;
        return path;}

    function price(address token, MarketV2 marketV2) internal view returns (uint256 r18) {
        return token.toPair(marketV2).price(marketV2);}
    
    function value(address token, MarketV2 marketV2) internal view returns (uint256 r18) {
        return token.balance() * token.price(marketV2);}

    function balance(address token) internal view returns (uint256 r18) {
        token.token().balanceOf(address(this)).fromAnyToEtherDecimals(token.token().decimals());}

    function buy(address token, MarketV2 marketV2, uint256 r18AmountIn) internal returns (uint256 r18) {
        return token.toPair(marketV2).swap(marketV2, r18AmountIn);}

    function sell(address token, MarketV2 marketV2, uint256 r18AmountIn) internal returns (uint256 r18) {
        return token.toReversePair(marketV2).swap(marketV2, r18AmountIn);}
    
    function buyWithPath(address token, MarketV2 marketV2, uint256 r18AmountIn, IERC20[] memory routes) internal returns (uint256 r18) {
        return token.toPath(marketV2, routes).swap(marketV2, r18AmountIn);}

    function sellWithPath(address token, Market marketV2, uint256 r18AmountIn, IERC20[] memory routes) internal returns (uint256 r18) {
        return token.toReversePath(marketV2, routes).swap(marketV2, r18AmountIn);}}