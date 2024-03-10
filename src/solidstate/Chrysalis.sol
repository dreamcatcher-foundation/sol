// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import '../non-native/solidstate/contracts/proxy/diamond/SolidStateDiamond.sol';
import '../non-native/solidstate/contracts/proxy/diamond/ISolidStateDiamond.sol';
import '../non-native/solidstate/contracts/proxy/diamond/readable/IDiamondReadable.sol';
import '../non-native/solidstate/contracts/proxy/diamond/writable/IDiamondWritable.sol';
import '../non-native/solidstate/contracts/proxy/diamond/writable/IDiamondWritableInternal.sol';
import '../interface/IConsole.sol';

contract Chrysalis is SolidStateDiamond {
    function addSelectors(address implementation, bytes4[] memory selectors) public onlyOwner() returns (bool) {
        IDiamondWritableInternal.FacetCutAction action = IDiamondWritableInternal.FacetCutAction.ADD;
        IDiamondWritableInternal.FacetCut memory facetCut = IDiamondWritableInternal.FacetCut(implementation, action, selectors);
        IDiamondWritable client = IDiamondWritable(address(this));
        IDiamondWritableInternal.FacetCut[] memory facetCuts;
        facetCuts = new IDiamondWritableInternal.FacetCut[](1);
        facetCuts[0] = facetCut;
        client.diamondCut(facetCuts, address(this), '');
        return true;
    }
    
    function removeSelectors(address implementation, bytes4[] memory selectors) public onlyOwner() returns (bool) {
        IDiamondWritableInternal.FacetCutAction action = IDiamondWritableInternal.FacetCutAction.REMOVE;
        IDiamondWritableInternal.FacetCut memory facetCut = IDiamondWritableInternal.FacetCut(implementation, action, selectors);
        IDiamondWritable client = IDiamondWritable(address(this));
        IDiamondWritableInternal.FacetCut[] memory facetCuts;
        facetCuts = new IDiamondWritableInternal.FacetCut[](1);
        facetCuts[0] = facetCut;
        client.diamondCut(facetCuts, address(this), '');
        return true;
    }

    function install(address console) public onlyOwner()returns (bool) {
        IConsole consoleInterface = IConsole(console);
        bytes4[] memory selectors = consoleInterface.selectors();
        addSelectors(console, selectors);
        return true;
    }

    function uninstall(address console) public onlyOwner()returns (bool) {
        IConsole consoleInterface = IConsole(console);
        bytes4[] memory selectors = consoleInterface.selectors();
        removeSelectors(console, selectors);
        return true;
    }
}