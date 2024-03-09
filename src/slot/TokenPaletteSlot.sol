// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import '../../imports/openzeppelin/utils/structs/EnumerableSet.sol';
import '../interface/IToken.sol';
import '../library/ConversionLibrary.sol';

contract TokenPaletteSlot {
    using EnumerableSet for EnumerableSet.AddressSet;
    using ConversionLibrary for uint;

    struct TokenPalette {
        EnumerableSet.AddressSet _tokenContracts;
    }

    // MEMORY
    bytes32 constant internal TOKEN_PALETTE = bytes32(uint256(keccak256('eip1967.TOKEN_PALETTE')) - 1);

    function tokenPalette() internal pure returns (TokenPalette storage sl) {
        bytes32 location = TOKEN_PALETTE;
        assembly {
            sl.slot := location
        }
    }

    // EVENTS
    event TokenPalette__TokenContractAdded(address tokenContract);
    event TokenPalette__TokenContractRemoved(address tokenContract);

    // PROPERTIES
    function __tokenPalette__tokenContracts(uint256 tokenContractId) internal view returns (address) {
        return tokenPalette()._tokenContracts.at(tokenContractId);
    }

    function __tokenPalette__tokenContracts() internal view returns (address[] memory) {
        return tokenPalette()._tokenContracts.values();
    }

    function __tokenPalette__hasTokenContract(address tokenContract) internal view returns (bool) {
        return tokenPalette()._tokenContracts.contains(tokenContract);
    }

    function __tokenPalette__tokenContractsLength() internal view returns (uint256) {
        return tokenPalette()._tokenContracts.length();
    }

    function __tokenPalette__maximumTokenContractsLength() internal pure returns (uint256) {
        return 32;
    }

    function __tokenPalette__addTokenContract(address tokenContract) internal returns (bool) {
        if (!__tokenPalette__hasTokenContract(tokenContract)) {
            __tokenPalette__beforeTokenContractAdded(tokenContract);
            require(__tokenPalette__tokenContractsLength() < __tokenPalette__maximumTokenContractsLength(), 'TokenPaletteSlot: too many token contracts');
            tokenPalette()._tokenContracts.add(tokenContract);
            emit TokenPalette__TokenContractAdded(tokenContract);
            __tokenPalette__afterTokenContractAdded(tokenContract);
        }
        return true;
    }

    function __tokenPalette__removeTokenContract(address tokenContract) internal returns (bool) {
        if (__tokenPalette__hasTokenContract(tokenContract)) {
            __tokenPalette__beforeTokenContractRemoved(tokenContract);
            tokenPalette()._tokenContracts.remove(tokenContract);
            emit TokenPalette__TokenContractRemoved(tokenContract);
            __tokenPalette__afterTokenContractRemoved(tokenContract);
        }
        return true;
    }

    // HOOK
    function __tokenPalette__beforeTokenContractAdded(address tokenContract) internal virtual returns (bool) {
        return true;
    }

    function __tokenPalette__afterTokenContractAdded(address tokenContract) internal virtual returns (bool) {
        return true;
    }

    function __tokenPalette__beforeTokenContractRemoved(address tokenContract) internal virtual returns (bool) {
        return true;
    }

    function __tokenPalette__afterTokenContractRemoved(address tokenContract) internal virtual returns (bool) {
        return true;
    }

    function __tokenPalette__beforeTokenApproved(uint256 tokenContractId, address spender, uint256 amountR18) internal virtual returns (bool) {
        return true;
    }

    function __tokenPalette__afterTokenApproved(uint256 tokenContractId, address spender, uint256 amountR18) internal virtual returns (bool) {
        return true;
    }

    function __tokenPalette__beforeTokenTransferred(uint256 tokenContractId, address to, uint256 amountR18) internal virtual returns (bool) {
        return true;
    }

    function __tokenPalette__afterTokenTransferred(uint256 tokenContractId, address to, uint256 amount18) internal virtual returns (bool) {
        return true;
    }

    function __tokenPalette__beforeTokenTransferredFrom(uint256 tokenContractId, address from, address to, uint256 amountR18) internal virtual returns (bool) {
        return true;
    }

    function __tokenPalette__afterTokenTransferredFrom(uint256 tokenContractId, address from, address to, uint256 amountR18) internal virtual returns (bool) {
        return true;
    }

    // CONVERSION
    function __tokenPalette__tokenInterface(uint256 tokenContractId) internal view returns (IToken) {
        return IToken(__tokenPalette__tokenContracts(tokenContractId));
    }

    // TOKEN PALETTE TOKENS INTERFACE
    function __tokenPalette__tokenName(uint256 tokenContractId) internal view returns (string memory) {
        return __tokenPalette__tokenInterface(tokenContractId).name();
    }

    function __tokenPalette__tokenSymbol(uint256 tokenContractId) internal view returns (string memory) {
        return __tokenPalette__tokenInterface(tokenContractId).symbol();
    }

    function __tokenPalette__tokenDecimals(uint256 tokenContractId) internal view returns (uint8) {
        return __tokenPalette__tokenInterface(tokenContractId).decimals();
    }

    function __tokenPalette__tokenTotalSupply(uint256 tokenContractId) internal view returns (uint256 r18) {
        return __tokenPalette__tokenInterface(tokenContractId)
            .totalSupply()
            .fromRToR18(__tokenPalette__tokenDecimals(tokenContractId));
    }

    function __tokenPalette__tokenBalanceOf(uint256 tokenContractId, address account) internal view returns (uint256 r18) {
        return __tokenPalette__tokenInterface(tokenContractId)
            .balanceOf(account)
            .fromRToR18(__tokenPalette__tokenDecimals(tokenContractId));
    }

    function __tokenPalette__tokenBalance(uint256 tokenContractId) internal view returns (uint256 r18) {
        return __tokenPalette__tokenBalanceOf(tokenContractId, address(this));
    }

    function __tokenPalette__tokenAllowance(uint256 tokenContractId, address owner, address spender) internal view returns (uint256 r18) {
        return __tokenPalette__tokenInterface(tokenContractId)
            .allowance(owner, spender)
            .fromRToR18(__tokenPalette__tokenDecimals(tokenContractId));
    }

    function __tokenPalette__approveToken(uint256 tokenContractId, address spender, uint256 amountR18) internal returns (bool) {
        __tokenPalette__beforeTokenApproved(tokenContractId, spender, amountR18);
        __tokenPalette__tokenInterface(tokenContractId).approve(spender, amountR18.fromR18ToR(__tokenPalette__tokenDecimals(tokenContractId)));
        __tokenPalette__afterTokenApproved(tokenContractId, spender, amountR18);
        return true;
    }

    function __tokenPalette__transferToken(uint256 tokenContractId, address to, uint256 amountR18) internal returns (bool) {
        __tokenPalette__beforeTokenTransferred(tokenContractId, to, amountR18);
        __tokenPalette__tokenInterface(tokenContractId).transfer(to, amountR18.fromR18ToR(__tokenPalette__tokenDecimals(tokenContractId)));
        __tokenPalette__afterTokenTransferred(tokenContractId, to, amountR18);
        return true;
    }

    function __tokenPalette__transferFromToken(uint256 tokenContractId, address from, address to, uint256 amountR18) internal returns (bool) {
        __tokenPalette__beforeTokenTransferredFrom(tokenContractId, from, to, amountR18);
        __tokenPalette__tokenInterface(tokenContractId).transferFrom(from, to, amountR18.fromR18ToR(__tokenPalette__tokenDecimals(tokenContractId)));
        __tokenPalette__afterTokenTransferredFrom(tokenContractId, from, to, amountR18);
        return true;
    }
}