// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
* Constructor Instructions
*   
*   1. setName
*   2. setSymbol
*
 */
library TokenSlotLib {
    event Approval(address indexed owner, address indexed spender, uint256 indexed amount);
    event Transfer(address indexed from, address indexed to, uint256 indexed amount);
    event ChangedTokenName(string indexed name);
    event ChangedTokenSymbol(string indexed symbol);

    struct Token {
        mapping(address => uint256) __balances;
        mapping(address => mapping(address => uint256)) __allowances;
        uint256 __totalSupply;
        string __name;
        string __symbol;
    }

    function name(Token storage token) internal view returns (string memory) {
        return token.__name;
    }

    function symbol(Token storage token) internal view returns (string memory) {
        return token.__symbol;
    }

    function decimals(Token storage token) internal pure returns (uint8) {
        return 18;
    }

    function totalSupply(Token storage token) internal view returns (uint256) {
        return token.__totalSupply;
    }

    function balanceOf(Token storage token, address account) internal view returns (uint256) {
        return token.__balances[account];
    }

    function allowance(Token storage token, address owner, address spender) internal view returns (uint256) {
        return token.__allowances[owner][spender];
    }

    function setName(Token storage token, string memory name) internal returns (Token storage) {
        token.__name = name;
        emit ChangedTokenName(name);
        return token;
    }

    function setSymbol(Token storage token, string memory symbol) internal returns (Token storage) {
        token.__symbol = symbol;
        emit ChangedTokenSymbol(symbol);
        return token;
    }

    function transfer(Token storage token, address to, uint256 amount) internal returns (Token storage) {
        address owner = msg.sender;
        _transfer(token, owner, to, amount);
        return token;
    }

    function transferFrom(Token storage token, address from, address to, uint256 amount) internal returns (Token storage) {
        address spender = msg.sender;
        _spendAllowance(token, from, spender, amount);
        _transfer(token, from, to, amount);
        return token;
    }

    function mint(Token storage token, address account, uint256 amount) internal returns (Token storage) {
        return _mint(token, account, amount);
    }

    function burn(Token storage token, address account, uint256 amount) internal returns (Token storage) {
        return _burn(token, account, amount);
    }

    function approve(Token storage token, address spender, uint256 amount) internal returns (Token storage) {
        address owner = msg.sender;
        _approve(token, owner, spender, amount);
        return token;
    }

    function increaseAllowance(Token storage token, address spender, uint256 addedAmount) internal returns (Token storage) {
        address owner = msg.sender;
        _approve(token, owner, spender, allowance(token, owner, spender) + addedAmount);
        return token;
    }

    function decreaseAllowance(Token storage token, address spender, uint256 subtractedAmount) internal returns (Token storage) {
        address owner = msg.sender;
        uint256 currentAllowance = allowance(token, owner, spender);
        require(currentAllowance >= subtractedAmount, 'Token: cannot decrease allowance below zero');
        unchecked {
            _approve(token, owner, spender, currentAllowance - subtractedAmount);
        }
        return token;
    }

    function _transfer(Token storage token, address from, address to, uint256 amount) private returns (Token storage) {
        require(from != address(0), 'Token: cannot transfer from address zero');
        require(to != address(0), 'Token: cannot transfer to address zero');
        uint256 fromBalance = token.__balances[from];
        require(fromBalance >= amount, 'Token: insufficient balance');
        unchecked {
            token.__balances[from] = fromBalance - amount;
            token.__balances[to] += amount;
        }
        emit Transfer(from, to, amount);
        return token;
    }

    function _mint(Token storage token, address account, uint256 amount) private returns (Token storage) {
        require(account != address(0), 'Token: cannot mint to address zero');
        token.__totalSupply += amount;
        unchecked {
            token.__balances[account] += amount;
        }
        emit Transfer(address(0), account, amount);
        return token;
    }

    function _burn(Token storage token, address account, uint256 amount) private returns (Token storage) {
        require(account != address(0), 'Token: cannot burn from address zero');
        uint256 accountBalance = token.__balances[account];
        require(accountBalance >= amount, 'Token: insufficient balance');
        unchecked {
            token.__balances[account] = accountBalance - amount;
            token.__totalSupply -= amount;
        }
        emit Transfer(account, address(0), amount);
        return token;
    }

    function _approve(Token storage token, address owner, address spender, uint256 amount) private returns (Token storage) {
        require(owner != address(0), 'Token: cannot approve from address zero');
        require(spender != address(0), 'Token: cannot approve to address zero');
        token.__allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
        return token;
    }

    function _spendAllowance(Token storage token, address owner, address spender, uint256 amount) private returns (Token storage) {
        uint256 currentAllowance = allowance(token, owner, spender);
        if (currentAllowance != type(uint256).max) {
            require(currentAllowance >= amount, 'Token: insufficient allowance');
            unchecked {
                _approve(token, owner, spender, currentAllowance - amount);
            }
        }
        return token;
    }
}

contract TokenSlot {
    bytes32 constant internal TOKEN = bytes32(uint256(keccak256('eip1967.TOKEN')) - 1);

    function token() internal pure returns (TokenSlotLib.Token storage sl) {
        bytes32 location = TOKEN;
        assembly {
            sl.slot := location
        }
    }
}