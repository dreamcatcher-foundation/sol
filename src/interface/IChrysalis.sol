// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import '../../imports/solidstate/contracts/proxy/diamond/ISolidStateDiamond.sol';

interface IChrysalis is ISolidStateDiamond {
    function addSelectors(address implementation, bytes4[] memory selectors) external returns (bool);
    function removeSelectors(address implementation, bytes4[] memory selectors) external returns (bool);
    function install(address extension) external returns (bool);
    function uninstall(address extension) external returns (bool);
}