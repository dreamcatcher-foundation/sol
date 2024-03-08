// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import '../../imports/solidstate/contracts/proxy/diamond/SolidStateDiamond.sol';
import '../../imports/solidstate/contracts/proxy/diamond/ISolidStateDiamond.sol';
import '../../imports/solidstate/contracts/proxy/diamond/readable/IDiamondReadable.sol';
import '../../imports/solidstate/contracts/proxy/diamond/writable/IDiamondWritable.sol';
import '../../imports/solidstate/contracts/proxy/diamond/writable/IDiamondWritableInternal.sol';
import '../interface/IExtension.sol';

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

    function install(address extension) public onlyOwner()returns (bool) {
        return addSelectors(extension, IExtension(extension).selectors());
    }

    function uninstall(address extension) public onlyOwner()returns (bool) {
        return removeSelectors(extension, IExtension(extension).selectors());
    }
}