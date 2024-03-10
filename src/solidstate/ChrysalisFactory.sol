// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import '../interface/IToken.sol';
import '../interface/IClaimConsole.sol';
import '../interface/IManagerConsole.sol';
import '../interface/IOwnerConsole.sol';
import '../interface/IVaultConsole.sol';
import './Chrysalis.sol';
import '../library/ConversionLibrary.sol';

interface IVault is 
    IToken,
    IClaimConsole,
    IManagerConsole,
    IOwnerConsole,
    IVaultConsole {}

contract ChrysalisFactory {
    using ConversionLibrary for uint256;

    IClaimConsole    claimConsole;
    IManagerConsole  managerConsole;
    IOwnerConsole    ownerConsole;
    IToken           tokenConsole;
    IVaultConsole    vaultConsole;

    constructor(
        address _claimConsole,
        address _managerConsole,
        address _ownerConsole,
        address _tokenConsole,
        address _vaultConsole
    ) {
        claimConsole     = _claimConsole;
        managerConsole   = _managerConsole;
        ownerConsole     = _ownerConsole;
        tokenConsole     = _tokenConsole;
        vaultConsole     = _vaultConsole;
    }

    function deploy(string memory _name, string memory _symbol) external returns (address) {
        Chrysalis chrysalis = new Chrysalis();
        
        chrysalis.install(address(claimConsole));
        chrysalis.install(address(managerConsole));
        chrysalis.install(address(ownerConsole));
        chrysalis.install(address(tokenConsole));
        chrysalis.install(address(vaultConsole));

        IVault vault = IVault(chrysalis);

        vault.claimOwnership(_name, _symbol, 050000000000000000); // 0.05 WMATIC

        vault.addMemberTo('managers', msg.sender);

        return address(chrysalis);
    }
}