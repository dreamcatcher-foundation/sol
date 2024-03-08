// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import '../../imports/openzeppelin/token/ERC20/extensions/IERC20Metadata.sol';
import '../../imports/openzeppelin/token/ERC20/IERC20.sol';

interface IToken is IERC20, IERC20Metadata {}