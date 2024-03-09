// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import '../interface/IVaultExtension.sol';
import './Chrysalis.sol';

contract ChrysalisFactory {
    address private _vaultExtensionContract;

    constructor(address vaultExtensionContract) {
        _vaultExtensionContract = vaultExtensionContract;
    }

    function deploy() public returns (address) {
        Chrysalis chrysalis;
        chrysalis = new Chrysalis();
        chrysalis.install(_vaultExtensionContract);
        IVaultExtension vaultFacet = IVaultExtension(address(chrysalis));
        vaultFacet.vault__claim();
        vaultFacet.vault__grantManagerRoleTo(msg.sender);
        return address(chrysalis);
    }
}