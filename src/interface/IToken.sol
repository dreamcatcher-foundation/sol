// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import '../non-native/openzeppelin/token/ERC20/extensions/IERC20Metadata.sol';
import '../non-native/openzeppelin/token/ERC20/IERC20.sol';

interface IToken is IERC20, IERC20Metadata {
    function mint(address account, uint256 amount) external returns (bool);
    function burn(address account, uint256 amount) external returns (bool);
}