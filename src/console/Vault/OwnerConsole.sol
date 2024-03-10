// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import '../../slot/auth/AuthSlot.sol';
import '../../slot/asset/TokenSlot.sol';

contract OwnerConsole is AuthSlot, TokenSlot, MarketSlot, PaletteSlot {
    using AuthSlotLib for AuthSlotLib.Auth;
    using TokenSlotLib for TokenSlotLib.Token;

    function selectors() external view returns (bytes4[] memory response) {
        response = bytes4[](4);
        response[0] = bytes4(keccak256('addMemberTo(string,address)'));
        response[1] = bytes4(keccak256('removeMemberFrom(string,address)'));
        response[2] = bytes4(keccak256('mint(address,uint256)'));
        response[3] = bytes4(keccak256('burn(address,uint256)'));
        return response;
    }

    function addMemberTo(string memory role, address account) external returns (bool) {
        auth()
            .requireMembership(auth().ownerRole())
            .addMemberTo(role, account);
        return true;
    }

    function removeMemberFrom(string memory role, address account) external returns (bool) {
        auth()
            .requireMembership(auth().ownerRole())
            .removeMemberFrom(role, account);
        return true;
    }

    function mint(address account, uint256 amount) external returns (bool) {
        auth().requireMembership(auth().ownerRole());
        token().mint(account, amount);
        return true;
    }

    function burn(address account, uint256 amount) external returns (bool) {
        auth().requireMembership(auth().ownerRole());
        token().burn(account, amount);
        return true;
    }
}