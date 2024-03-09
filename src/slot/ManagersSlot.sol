// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import '../../../imports/openzeppelin/utils/structs/EnumerableSet.sol';

contract ManagersSlot {
    using EnumerableSet for EnumerableSet.AddressSet;

    struct Managers {
        EnumerableSet.AddressSet _members;
    }

    // MEMORY
    bytes32 constant internal MANAGERS = bytes32(uint256(keccak256('eip1967.MANAGERS')) - 1);

    function managers() internal pure returns (Managers storage sl) {
        bytes32 location = MANAGERS;
        assembly {
            sl.slot := location
        }
    }

    // EVENTS
    event Managers__RoleGranted(address account);
    event Managers__RoleRevoked(address account);

    // PROPERTIES
    function __managers__members(uint256 managerId) internal view returns (address) {
        return managers()._members.at(managerId);
    }

    function __managers__members() internal view returns (address[] memory) {
        return managers()._members.values();
    }

    function __managers__hasMember(address account) internal view returns (bool) {
        return managers()._members.contains(account);
    }

    function __managers__membersLength() internal view returns (uint256) {
        return managers()._members.length();
    }

    function __managers__grantRoleTo(address account) internal returns (bool) {
        if (!__managers__hasMember(account)) {
            __managers__beforeRoleGrantedTo(account);
            managers()._members.add(account);
            emit Managers__RoleGranted(account);
            __managers__afterRoleGrantedTo(account);
        }
        return true;
    }

    function __managers__revokeRoleFrom(address account) internal returns (bool) {
        if (__managers__hasMember(account)) {
            __managers__beforeRoleRevokedFrom(account);
            managers()._members.remove(account);
            emit Managers__RoleRevoked(account);
            __managers__afterRoleRevokedFrom(account);
        }
        return true;
    }

    // HOOKS
    function __managers__beforeRoleGrantedTo(address account) internal virtual returns (bool) {
        return true;
    }

    function __managers__afterRoleGrantedTo(address account) internal virtual returns (bool) {
        return true;
    }

    function __managers__beforeRoleRevokedFrom(address account) internal virtual returns (bool) {
        return true;
    }

    function __managers__afterRoleRevokedFrom(address account) internal virtual returns (bool) {
        return true;
    }

    function __managers__beforeMemberCheck(address account) internal virtual returns (bool) {
        return true;
    }

    function __managers__afterMemberCheck(address account) internal virtual returns (bool) {
        return true;
    }

    // GUARDS
    function __managers__onlyMember(address account) internal view returns (bool) {
        __managers__beforeMemberCheck(account);
        require(__managers__hasMember(account), 'ManagersSlot: unauthorized');
        __managers__afterMemberCheck(account);
        return true;
    }

    function __managers__onlyMember() internal view returns (bool) {
        return __managers__onlyMember(msg.sender);
    }
}