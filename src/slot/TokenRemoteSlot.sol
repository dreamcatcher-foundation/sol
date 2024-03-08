// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import '../interface/IRemoteToken.sol';
import '../library/ConversionLibrary.sol';

contract TokenRemoteSlot {
    using ConversionLibrary for uint256;

    struct TokenRemote {
        address _controlledTokenContract;
    }

    // MEMORY
    bytes32 constant internal TOKEN_REMOTE = bytes32(uint256(keccak256('eip1967.TOKEN_REMOTE')));

    function tokenRemote() internal pure returns (TokenRemote storage sl) {
        bytes32 location = TOKEN_REMOTE;
        assembly {
            sl.slot := location
        }
    }

    // EVENTS
    event TokenRemote__ControlledTokenContractChanged(address oldTokenContract, address newTokenContract);

    // PROPERTIES
    function __tokenRemote__controlledTokenContract() internal view returns (address) {
        return tokenRemote()._controlledTokenContract;
    }

    function __tokenRemote__changeControlledTokenContract(address newTokenContract) internal returns (bool) {
        __tokenRemote__beforeControlledTokenContractChanged(newTokenContract);
        address oldTokenContract = __tokenRemote__controlledTokenContract();
        tokenRemote()._controlledTokenContract = newTokenContract;
        emit TokenRemote__ControlledTokenContractChanged(oldTokenContract, newTokenContract);
        __tokenRemote__afterControlledTokenContractChanged(newTokenContract)
        return true;
    }

    // HOOKS
    function __tokenRemote__beforeControlledTokenContractChanged(address newTokenContract) internal virtual returns (bool) {
        return true;
    }

    function __tokenRemote__afterControlledTokenContractChanged(address newTokenContract) internal virtual returns (bool) {
        return true;
    }

    function __tokenRemote__beforeControlledTokenApproved(address spender, uint256 amountR18) internal virtual returns (bool) {
        return true;
    }

    function __tokenRemote__afterControlledTokenApproved(address spender, uint256 amountR18) internal virtual returns (bool) {
        return true;
    }

    function __tokenRemote__beforeControlledTokenTransfer(address to, uint256 amountR18) internal virtual returns (bool) {
        return true;
    }

    function __tokenRemote__afterControlledTokenTransferred(address to, uint256 amountR18) internal virtual returns (bool) {
        return true;
    }

    function __tokenRemote__beforeControlledTokenTransferredFrom(address from, address to, uint256 amountR18) internal virtual returns (bool) {
        return true;
    }

    function __tokenRemote__afterControlledTokenTransferredFrom(address from, address to, uint256 amountR18) internal virtual returns (bool) {
        return true;
    }

    function __tokenRemote__beforeControlledTokenMinted(address to, uint256 amountR18) internal virtual returns (bool) {
        return true;
    }

    function __tokenRemote__afterControlledTokenMinted(address to, uint256 amountR18) internal virtual returns (bool) {
        return true;
    }

    function __tokenRemote__beforeControlledTokenBurned(address from, uint256 amountR18) internal virtual returns (bool) {
        return true;
    }

    function __tokenRemote__afterControlledTokenBurned(address from, uint256 amountR18) internal virtual returns (bool) {
        return true;
    }

    // GUARDS
    function __tokenRemote__onlyWhenControllingTokenContract() internal view returns (bool) {
        require(__tokenRemote__controlledTokenContract() != address(0), 'TokenRemoteSlot: is not controlling any token contract');
    }

    // CONVERSION
    function __tokenRemote__controlledTokenInterface() internal view returns (IRemoteToken) {
        return IRemoteToken(__tokenRemote__controlledTokenContract());
    }

    // TOKEN INTERFACE
    function __tokenRemote__controlledTokenName() internal view returns (string memory) {
        return __tokenRemote__controlledTokenInterface().name();
    }

    function __tokenRemote__controlledTokenSymbol() internal view returns (string memory) {
        return __tokenRemote__controlledTokenInterface().symbol();
    }

    function __tokenRemote__controlledTokenDecimals() internal view returns (uint8) {
        return __tokenRemote__controlledTokenInterface().decimals();
    }

    function __tokenRemote__controlledTokenTotalSupply() internal view returns (uint256 r18) {
        return __tokenRemote__controlledTokenInterface()
            .totalSupply()
            .fromRToR18(__tokenRemote__controlledTokenDecimals());
    }

    function __tokenRemote__controlledTokenBalanceOf(address account) internal view returns (uint256 r18) {
        return __tokenRemote__controlledTokenInterface()
            .balanceOf(account)
            .fromRToR18(__tokenRemote__controlledTokenDecimals());
    }

    function __tokenRemote__controlledTokenBalance() internal view returns (uint256 r18) {
        return __tokenRemote__controlledTokenBalanceOf(address(this));
    }

    function __tokenRemote__controlledTokenAllowance(address owner, address spender) internal view returns (uint256 r18) {
        return __tokenRemote__controlledTokenInterface()
            .allowance(owner, spender)
            .fromRToR18(__tokenRemote__controlledTokenDecimals());
    }

    function __tokenRemote__approveControlledToken(address spender, uint256 amountR18) internal returns (bool) {
        __tokenRemote__beforeControlledTokenApproved(spender, amountR18);
        __tokenRemote__controlledTokenInterface().approve(spender, amountR18.fromR18ToR(__tokenRemote__controlledTokenDecimals()));
        __tokenRemote__afterControlledTokenApproved(spender, amountR18);
        return true;
    }

    function __tokenRemote__transferControlledToken(address to, uint256 amountR18) internal returns (bool) {
        __tokenRemote__beforeControlledTokenTransfer(to, amountR18);
        __tokenRemote__controlledTokenInterface().transfer(to, amountR18.fromR18ToR(__tokenRemote__controlledTokenDecimals()));
        __tokenRemote__afterControlledTokenTransferred(to, amountR18);
        return true;
    }

    function __tokenRemote__transferFromControlledToken(address from, address to, uint256 amountR18) internal returns (bool) {
        __tokenRemote__beforeControlledTokenTransferredFrom(from, to, amountR18);
        __tokenRemote__controlledTokenInterface().transferFrom(from, to, amountR18.fromR18ToR(__tokenRemote__controlledTokenDecimals()));
        __tokenRemote__afterControlledTokenTransferredFrom(from, to, amountR18);
        return true;
    }

    function __tokenRemote__mintControlledToken(address to, uint256 amountR18) internal returns (bool) {
        __tokenRemote__beforeControlledTokenMinted(to, amountR18);
        __tokenRemote__controlledTokenInterface().mint(to, amountR18.fromR18ToR(__tokenRemote__controlledTokenDecimals()));
        __tokenRemote__afterControlledTokenMinted(to, amountR18);
        return true;
    }

    function __tokenRemote__burnControlledToken(address from, uint256 amountR18) internal returns (bool) {
        __tokenRemote__beforeControlledTokenBurned(from, amountR18);
        __tokenRemote__controlledTokenInterface().burn(from, amountR18.fromR18ToR(__tokenRemote__controlledTokenDecimals()));
        __tokenRemote__afterControlledTokenBurned(from, amountR18);
        return true;
    }
}