// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import '../interface/IToken.sol';
import '../library/ConversionLibrary.sol';
import './TokenPaletteSlot.sol';
import './MarketV2Slot.sol';

contract VaultSlot is TokenPaletteSlot, MarketV2Slot {
    using ConversionLibrary for uint256;

    struct Vault {
        address _denominatorTokenContract;
    }

    // MEMORY
    bytes32 constant internal VAULT = bytes32(uint256(keccak256('eip1967.VAULT')) - 1);

    function vault() internal pure returns (Vault storage sl) {
        bytes32 location = VAULT;
        assembly {
            sl.slot := location
        }
    }

    // EVENTS
    event Vault__DenominatorTokenContractChanged(address oldDenominatorTokenContract, address newDenominatorTokenContract);

    // PROPERTIES
    function __vault__denominatorTokenContract() internal view returns (address) {
        return vault()._denominatorTokenContract;
    }

    function __vault__changeDenominatorTokenContract(address newDenominatorTokenContract) internal returns (bool) {
        __vault__beforeDenominatorTokenContractChanged(newDenominatorTokenContract);
        address oldDenominatorTokenContract = __vault__denominatorTokenContract();
        vault()._denominatorTokenContract = newDenominatorTokenContract;
        emit Vault__DenominatorTokenContractChanged(oldDenominatorTokenContract, newDenominatorTokenContract);
        __vault__afterDenominatorTokenContractChanged(newDenominatorTokenContract);
        return true;
    }

    // HOOKS
    function __vault__beforeDenominatorTokenContractChanged(address newDenominatorTokenContract) internal virtual returns (bool) {
        return true;
    }

    function __vault__afterDenominatorTokenContractChanged(address newDenominatorTokenContract) internal virtual returns (bool) {
        return true;
    }

    function __vault__beforeDenominatorTokenApproved(address spender, uint256 amountR18) internal virtual returns (bool) {
        return true;
    }

    function __vault__afterDenominatorTokenApproved(address spender, uint256 amountR18) internal virtual returns (bool) {
        return true;
    }

    function __vault__beforeDenominatorTokenTransferred(address to, uint256 amountR18) internal virtual returns (bool) {
        return true;
    }

    function __vault__afterDenominatorTokenTransferred(address to, uint256 amountR18) internal virtual returns (bool) {
        return true;
    }

    function __vault__beforeDenominatorTokenTransferredFrom(address from, address to, uint256 amountR18) internal virtual returns (bool) {
        return true;
    }

    function __vault__afterDenominatorTokenTransferredFrom(address from, address to, uint256 amountR18) internal virtual returns (bool) {
        return true;
    }

    // CONVERSION
    function __vault__denominatorTokenInterface() internal view returns (IToken) {
        return IToken(__vault__denominatorTokenContract());
    }

    // DENOMINATOR TOKEN INTERFACE
    function __vault__denominatorTokenName() internal view returns (string memory) {
        return __vault__denominatorTokenInterface().name();
    }

    function __vault__denominatorTokenSymbol() internal view returns (string memory) {
        return __vault__denominatorTokenInterface().symbol();
    }

    function __vault__denominatorTokenDecimals() internal view returns (uint8) {
        return __vault__denominatorTokenInterface().decimals();
    }

    function __vault__denominatorTokenTotalSupply() internal view returns (uint256 r18) {
        return __vault__denominatorTokenInterface()
            .totalSupply()
            .fromRToR18(__vault__denominatorTokenDecimals());
    }

    function __vault__denominatorTokenBalanceOf(address account) internal view returns (uint256 r18) {
        return __vault__denominatorTokenInterface()
            .balanceOf(account)
            .fromRToR18(__vault__denominatorTokenDecimals());
    }

    function __vault__denominatorTokenBalance() internal view returns (uint256 r18) {
        return __vault__denominatorTokenBalanceOf(address(this));
    }

    function __vault__denominatorTokenAllowance(address owner, address spender) internal view returns (uint256 r18) {
        return __vault__denominatorTokenInterface()
            .allowance(owner, spender)
            .fromRToR18(__vault__denominatorTokenDecimals());
    }

    function __vault__approveDenominatorToken(address spender, uint256 amountR18) internal returns (bool) {
        __vault__beforeDenominatorTokenApproved(spender, amountR18);
        __vault__denominatorTokenInterface().approve(spender, amountR18.fromR18ToR(__vault__denominatorTokenDecimals()));
        __vault__afterDenominatorTokenApproved(spender, amountR18);
        return true;
    }

    function __vault__transferDenominatorToken(address to, uint256 amountR18) internal returns (bool) {
        __vault__beforeDenominatorTokenTransferred(to, amountR18);
        __vault__denominatorTokenInterface().transfer(to, amountR18.fromR18ToR(__vault__denominatorTokenDecimals()));
        __vault__afterDenominatorTokenTransferred(to, amountR18);
        return true;
    }

    function __vault__transferFromDenominatorToken(address from, address to, uint256 amountR18) internal returns (bool) {
        __vault__beforeDenominatorTokenTransferredFrom(from, to, amountR18);
        __vault__denominatorTokenInterface().transferFrom(from, to, amountR18.fromR18ToR(__vault__denominatorTokenDecimals()));
        __vault__afterDenominatorTokenTransferredFrom(from, to, amountR18);
        return true;
    }

    // FINANCE
    function __vault__balance() internal view returns (uint256 r18) {
        uint256 balance;
        for (uint256 i = 0; i < __tokenPalette__tokenContractsLength(); i++) {
            address[] memory pair = address[](2);
            pair[0] = __tokenPalette__tokenContracts(i);
            pair[1] = __vault__denominatorTokenContract();
            balance += __tokenPalette__tokenBalance(i) * __marketV2__amountOut(pair);
        }
        return balance;
    }
}