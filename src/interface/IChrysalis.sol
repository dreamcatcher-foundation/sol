// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import '../../non-native/solidstate/contracts/proxy/diamond/ISolidStateDiamond.sol';

interface IChrysalis is ISolidStateDiamond {
    function addSelectors(address implementation, bytes4[] memory selectors) external returns (bool);
    function removeSelectors(address implementation, bytes4[] memory selectors) external returns (bool);
    function install(address console) external returns (bool);
    function uninstall(address console) external returns (bool);
}