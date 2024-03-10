// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import '../../non-native/openzeppelin/utils/structs/EnumerableSet.sol';

/**
* NOTE '*' represents the ownership role. This is not to be confused with
*      the ownership role on the Chrysalis which is managed separately
*      from the implementation. The Chrysalis ownership represents the
*      highest level of ownership over the control, and the '*' role
*      represents the second highest role.
*
* NOTE A claimOwnership function is provided within this library because
*      implementations must not have constructors.
*
* */
library AuthSlotLib {
    using EnumerableSet for EnumerableSet.AddressSet;

    event GrantedRole(string indexed role, address indexed account);
    event RevokedRole(string indexed role, address indexed account);

    struct Auth {
        mapping(string => EnumerableSet.AddressSet) __members;
    }

    function ownerRole(Auth storage auth) internal pure returns (string memory) {
        return '*';
    }

    function requireMembership(Auth storage auth, string memory role, address account) internal view returns (Auth storage) {
        require(isMemberOf(auth, role, account), 'Auth: missing membership');
        return auth;
    }

    function requireMembership(Auth storage auth, string memory role) internal view returns (Auth storage) {
        return requireMembership(auth, role, msg.sender);
    }

    function membersOf(Auth storage auth, string memory role) internal view returns (address[] memory) {
        return auth.__members[role].values();
    }

    function membersLengthOf(Auth storage auth, string memory role) internal view returns (uint256) {
        return auth.__members[role].length();
    }

    function isMemberOf(Auth storage auth, string memory role, address account) internal view returns (bool) {
        return auth.__members[role].contains(account);
    }

    function addMemberTo(Auth storage auth, string memory role, address account) internal returns (Auth storage) {
        auth.__members[role].add(account);
        emit GrantedRole(role, account);
        return auth;
    }

    function removeMemberFrom(Auth storage auth, string memory role, address account) internal returns (Auth storage) {
        auth.__members[role].remove(account);
        emit RevokedRole(role, account);
        return auth;
    }

    function claimOwnership(Auth storage auth) internal returns (Auth storage) {
        require(membersLengthOf(auth, ownerRole()) == 0, 'Auth: ownership can only be claimed when there are no owners');
        addMemberTo(auth, ownerRole(), msg.sender);
        return auth;
    }
}

contract AuthSlot {
    bytes32 constant internal AUTH = bytes32(uint256(keccak256('eip1967.AUTH')) - 1);

    function auth() internal pure returns (AuthSlotLib.Auth storage sl) {
        bytes32 location = AUTH;
        assembly {
            sl.slot := location
        }
    }
}