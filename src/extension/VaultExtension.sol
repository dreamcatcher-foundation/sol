// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import '../slot/core/OperatorsSlot.sol';
import '../slot/ManagersSlot.sol';
import '../slot/MarketV2Slot.sol';
import '../slot/TokenPaletteSlot.sol';
import '../slot/TokenRemoteSlot.sol';
import '../slot/VaultSlot.sol';
import '../library/VaultLibrary.sol';

contract VaultExtension is OperatorsSlot, ManagersSlot, MarketV2Slot, TokenPaletteSlot, TokenRemoteSlot, VaultSlot {
    // INSTALL
    function selectors() public view returns (bytes4[] memory) {
        return [
            bytes4('vault__claim()'),
            bytes4('vault__grantManagerRoleTo(address)'),
            bytes4('vault__buy(uint256, uint256)'),
            bytes4('vault__sell(uint256, uint256)'),
            bytes4('vault__addTokenToPalette(address)'),
            bytes4('vault__amountOut(uint256)'),
            bytes4('vault__valueOut(uint256)'),
            bytes4('vault__deposit(uint256)'),
            bytes4('vault__withdraw(uint256)'),
            bytes4('vault__netAssetValue()'),
            bytes4('vault__netAssetValuePerShare()'),
            bytes4('vault__tokenContracts(uint256)'),
            bytes4('vault__tokenContracts()')
        ];
    }

    // CLAIM
    function vault__claim() public returns (bool) {
        return __operators__claim();
    }

    // OPERATORS COMMANDS
    function vault__grantManagerRoleTo(address account) public returns (bool) {
        __operators__onlyMember();
        return __managers__grantRoleTo(account);
    }

    // MANAGERS COMMANDS
    function vault__buy(uint256 tokenContractId, uint256 amountInR18) public returns (bool) {
        __managers__onlyMember();
        address[] path = address()[2];
        path[0] = __vault__denominatorTokenContract();
        path[1] = __tokenPalette__tokenContracts(tokenContractId);
        __marketV2__swap(path, amountInR18);
        return true;
    }

    function vault__sell(uint256 tokenContractId, uint256 amountInR18) public returns (bool) {
        __managers__onlyMember();
        address[] path = address()[2];
        path[0] = __tokenPalette__tokenContracts(tokenContractId);
        path[1] = __vault__denominatorTokenContract();
        __marketV2__swap(path, amountInR18);
        return true;
    }

    function vault__addTokenToPalette(address tokenContract) public returns (bool) {
        __managers__onlyMember();
        require(__marketV2__amountOut([
            tokenContract,
            __vault__denominatorTokenContract()
        ]) != 0, 'VaultExtension: token does not have a pair with the vault denominator');
        __tokenPalette__addTokenContract(tokenContract);
        return true;
    }

    // PUBLIC
    function vault__amountOut(uint256 valueInR18) public view returns (uint256 r18) {
        return VaultLibrary.amountToMint(valueInR18, __tokenRemote__controlledTokenBalance(), __tokenRemote__controlledTokenTotalSupply());
    }

    function vault__valueOut(uint256 amountInR18) public view returns (uint256 r18) {
        return VaultLibrary.amountToSend(amountInR18, __tokenRemote__controlledTokenBalance(), __tokenRemote__controlledTokenTotalSupply());
    }

    function vault__deposit(uint256 valueInR18) public returns (bool) {
        __vault__transferFromDenominatorToken(msg.sender, address(this), valueInR18);
        __tokenRemote__mintControlledToken(msg.sender, vault__amountOut(valueInR18));
        return true;
    }

    function vault__withdraw(uint256 amountInR18) public returns (bool) {
        uint256 portionBp = (amountInR18 / __tokenRemote__controlledTokenTotalSupply()) * 10000;
        uint256[] out = uint256[](__tokenPalette__tokenContractsLength());
        for (uint256 i = 0; i < __tokenPalette__tokenContractsLength(); i++) {
            uint256 amountToSwapR18 = (__tokenPalette__tokenBalance(i) / 10000) * portionBp;
            address path = address[](2);
            path[0] = __tokenPalette__tokenContracts(i);
            path[1] = __vault__denominatorTokenContract();
            uint256 amountOut = __marketV2__swap(path, amountToSwapR18);
            __vault__transferDenominatorToken(msg.sender, amountOut);
        }
        return true;
    }

    // FINANCE
    function vault__netAssetValue() public view returns (uint256 r18) {
        return __vault__balance();
    }

    function vault__netAssetValuePerShare() public view returns (uint256 r18) {
        return vault__netAssetValue() / __tokenRemote__controlledTokenTotalSupply();
    }

    // TOKEN PALETTE
    function vault__tokenContracts(uint256 tokenContractId) public view returns (address) {
        return __tokenPalette__tokenContracts(tokenContractId);
    }

    function vault__tokenContracts() public view returns (address[] memory) {
        return __tokenPalette__tokenContracts();
    }
}