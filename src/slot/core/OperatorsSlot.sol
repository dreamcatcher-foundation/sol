// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import '../../../imports/openzeppelin/utils/structs/EnumerableSet.sol';

contract OperatorsSlot {
    using EnumerableSet for EnumerableSet.AddressSet;

    struct Operators {
        EnumerableSet.AddressSet _members;
    }

    // MEMORY
    bytes32 constant internal OPERATORS = bytes32(uint256(keccak256('eip1967.OPERATORS')) - 1);

    function operators() internal pure returns (Operators storage sl) {
        bytes32 location = OPERATORS;
        assembly {
            sl.slot := location
        }
    }

    // EVENTS
    event OperatorsSlot__Claimed(address account);
    event OperatorsSlot__RoleGranted(address account);
    event OperatorsSlot__RoleRevoked(address account);

    // FOR INITIAL CLAIMING PROCESS
    function __operators__claim() internal returns (bool) {
        __operators__beforeClaim();
        require(__operators__membersLength() == 0, 'OperatorsSlot: can only be claimed if there are no operators');
        __operators__grantRoleTo(msg.sender);
        emit OperatorsSlot__Claimed(msg.sender);
        __operators__afterClaim();
        return true;
    }

    // PROPERTIES
    function __operators__members(uint256 operatorId) internal view returns (address) {
        return operators()._members.at(operatorId);
    }

    function __operators__members() internal view returns (address[] memory) {
        return operators()._members.values();
    }

    function __operators__hasMember(address account) internal view returns (bool) {
        return operators()._members.contains(account);
    }

    function __operators__membersLength() internal view returns (uint256) {
        return operators()._members.length();
    }

    function __operators__grantRoleTo(address account) internal returns (bool) {
        if (!__operators__hasMember(account)) {
            __operators__beforeRoleGrantedTo(account);
            operators()._members.add(account);
            emit OperatorsSlot__RoleGranted(account);
            __operators__afterRoleGrantedTo(account);
        }
        return true;
    }

    function __operators__revokeRoleFrom(address account) internal returns (bool) {
        if (__operators__hasMember(account)) {
            __operators__beforeRoleRevokedFrom(account);
            operators()._members.remove(account);
            emit OperatorsSlot__RoleRevoked(account);
            __operators__afterRoleRevokedFrom(account);
        }
        return true;
    }

    // HOOKS
    function __operators__beforeRoleGrantedTo(address account) internal virtual returns (bool) {
        return true;
    }

    function __operators__afterRoleGrantedTo(address account) internal virtual returns (bool) {
        return true;
    }

    function __operators__beforeRoleRevokedFrom(address account) internal virtual returns (bool) {
        return true;
    }

    function __operators__afterRoleRevokedFrom(address account) internal virtual returns (bool) {
        return true;
    }

    function __operators__beforeMemberCheck(address account) internal virtual returns (bool) {
        return true;
    }

    function __operators__afterMemberCheck(address account) internal virtual returns (bool) {
        return true;
    }

    function __operators__beforeClaim() internal virtual returns (bool) {
        return true;
    }

    function __operators__afterClaim() internal virtual returns (bool) {
        return true;
    }

    // GUARDS
    function __operators__onlyMember(address account) internal view returns (bool) {
        __operators__beforeMemberCheck(account);
        require(__operators__hasMember(account), 'OperatorsSlot: unauthorized');
        __operators__afterMemberCheck(account);
        return true;
    }

    function __operators__onlyMember() internal view returns (bool) {
        return __operators__onlyMember(msg.sender);
    }
}