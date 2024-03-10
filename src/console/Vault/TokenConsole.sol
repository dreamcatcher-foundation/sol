// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import '../../slot/asset/TokenSlot.sol';

contract TokenConsole is TokenSlot {
    using TokenSlotLib for TokenSlotLib.Token;

    function selectors() external view returns (bytes4[] memory response) {
        response = bytes4[](11);
        response[0] = bytes4(keccak256('name()'));
        response[1] = bytes4(keccak256('symbol()'));
        response[2] = bytes4(keccak256('decimals()'));
        response[3] = bytes4(keccak256('totalSupply()'));
        response[4] = bytes4(keccak256('balanceOf(address)'));
        response[5] = bytes4(keccak256('allowance(address,address)'));
        response[6] = bytes4(keccak256('transfer(address,uint256)'));
        response[7] = bytes4(keccak256('transferFrom(address,address,uint256)'));
        response[8] = bytes4(keccak256('approve(address,uint256)'));
        response[9] = bytes4(keccak256('increaseAllowance(address,uint256)'));
        response[10] = bytes4(keccak256('decreaseAllowance(address,uint256)'));
        return response;
    }

    function name() external view returns (string memory) {
        return token().name();
    }

    function symbol() external view returns (string memory) {
        return token().symbol();
    }

    function decimals() external view returns (uint8) {
        return token().decimals();
    }

    function totalSupply() external view returns (uint256) {
        return token().totalSupply();
    }

    function balanceOf(address account) external view returns (uint256) {
        return token().balanceOf(account);
    }

    function allowance(address owner, address spender) external view returns (uint256) {
        return token().allowance(owner, spender);
    }

    function transfer(address to, uint256 amount) external returns (bool) {
        token().transfer(to, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) external returns (bool) {
        token().transferFrom(from, to, amount);
        return true;
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        token().approve(spender, amount);
        return true;
    }

    function increaseAllowance(address spender, uint256 addedAmount) external returns (bool) {
        token().increaseAllowance(spender, addedAmount);
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedAmount) external returns (bool) {
        token().decreaseAllowance(spender, subtractedAmount);
        return true;
    }
}