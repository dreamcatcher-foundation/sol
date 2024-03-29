// Sources flattened with hardhat v2.21.0 https://hardhat.org

// SPDX-License-Identifier: MIT

// File src/non-native/openzeppelin/token/ERC20/IERC20.sol

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.19;

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `from` to `to` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}


// File src/non-native/openzeppelin/token/ERC20/extensions/IERC20Metadata.sol

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)

pragma solidity ^0.8.19;
/**
 * @dev Interface for the optional metadata functions from the ERC20 standard.
 *
 * _Available since v4.1._
 */
interface IERC20Metadata is IERC20 {
    /**
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the symbol of the token.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the decimals places of the token.
     */
    function decimals() external view returns (uint8);
}


// File src/interface/IToken.sol

// Original license: SPDX_License_Identifier: MIT
pragma solidity ^0.8.0;
interface IToken is IERC20, IERC20Metadata {
    function mint(address account, uint256 amount) external returns (bool);
    function burn(address account, uint256 amount) external returns (bool);
}


// File src/slot/asset/TokenSlot.sol

// Original license: SPDX_License_Identifier: MIT
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


// File src/non-native/openzeppelin/utils/structs/EnumerableSet.sol

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (utils/structs/EnumerableSet.sol)
// This file was procedurally generated from scripts/generate/templates/EnumerableSet.js.

pragma solidity ^0.8.19;

/**
 * @dev Library for managing
 * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
 * types.
 *
 * Sets have the following properties:
 *
 * - Elements are added, removed, and checked for existence in constant time
 * (O(1)).
 * - Elements are enumerated in O(n). No guarantees are made on the ordering.
 *
 * ```solidity
 * contract Example {
 *     // Add the library methods
 *     using EnumerableSet for EnumerableSet.AddressSet;
 *
 *     // Declare a set state variable
 *     EnumerableSet.AddressSet private mySet;
 * }
 * ```
 *
 * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
 * and `uint256` (`UintSet`) are supported.
 *
 * [WARNING]
 * ====
 * Trying to delete such a structure from storage will likely result in data corruption, rendering the structure
 * unusable.
 * See https://github.com/ethereum/solidity/pull/11843[ethereum/solidity#11843] for more info.
 *
 * In order to clean an EnumerableSet, you can either remove all elements one by one or create a fresh instance using an
 * array of EnumerableSet.
 * ====
 */
library EnumerableSet {
    // To implement this library for multiple types with as little code
    // repetition as possible, we write it in terms of a generic Set type with
    // bytes32 values.
    // The Set implementation uses private functions, and user-facing
    // implementations (such as AddressSet) are just wrappers around the
    // underlying Set.
    // This means that we can only create new EnumerableSets for types that fit
    // in bytes32.

    struct Set {
        // Storage of set values
        bytes32[] _values;
        // Position of the value in the `values` array, plus 1 because index 0
        // means a value is not in the set.
        mapping(bytes32 => uint256) _indexes;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function _add(Set storage set, bytes32 value) private returns (bool) {
        if (!_contains(set, value)) {
            set._values.push(value);
            // The value is stored at length-1, but we add 1 to all indexes
            // and use 0 as a sentinel value
            set._indexes[value] = set._values.length;
            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function _remove(Set storage set, bytes32 value) private returns (bool) {
        // We read and store the value's index to prevent multiple reads from the same storage slot
        uint256 valueIndex = set._indexes[value];

        if (valueIndex != 0) {
            // Equivalent to contains(set, value)
            // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
            // the array, and then remove the last element (sometimes called as 'swap and pop').
            // This modifies the order of the array, as noted in {at}.

            uint256 toDeleteIndex = valueIndex - 1;
            uint256 lastIndex = set._values.length - 1;

            if (lastIndex != toDeleteIndex) {
                bytes32 lastValue = set._values[lastIndex];

                // Move the last value to the index where the value to delete is
                set._values[toDeleteIndex] = lastValue;
                // Update the index for the moved value
                set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
            }

            // Delete the slot where the moved value was stored
            set._values.pop();

            // Delete the index for the deleted slot
            delete set._indexes[value];

            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function _contains(Set storage set, bytes32 value) private view returns (bool) {
        return set._indexes[value] != 0;
    }

    /**
     * @dev Returns the number of values on the set. O(1).
     */
    function _length(Set storage set) private view returns (uint256) {
        return set._values.length;
    }

    /**
     * @dev Returns the value stored at position `index` in the set. O(1).
     *
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function _at(Set storage set, uint256 index) private view returns (bytes32) {
        return set._values[index];
    }

    /**
     * @dev Return the entire set in an array
     *
     * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
     * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
     * this function has an unbounded cost, and using it as part of a state-changing function may render the function
     * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
     */
    function _values(Set storage set) private view returns (bytes32[] memory) {
        return set._values;
    }

    // Bytes32Set

    struct Bytes32Set {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
        return _add(set._inner, value);
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
        return _remove(set._inner, value);
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
        return _contains(set._inner, value);
    }

    /**
     * @dev Returns the number of values in the set. O(1).
     */
    function length(Bytes32Set storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

    /**
     * @dev Returns the value stored at position `index` in the set. O(1).
     *
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
        return _at(set._inner, index);
    }

    /**
     * @dev Return the entire set in an array
     *
     * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
     * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
     * this function has an unbounded cost, and using it as part of a state-changing function may render the function
     * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
     */
    function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
        bytes32[] memory store = _values(set._inner);
        bytes32[] memory result;

        /// @solidity memory-safe-assembly
        assembly {
            result := store
        }

        return result;
    }

    // AddressSet

    struct AddressSet {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(AddressSet storage set, address value) internal returns (bool) {
        return _add(set._inner, bytes32(uint256(uint160(value))));
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(AddressSet storage set, address value) internal returns (bool) {
        return _remove(set._inner, bytes32(uint256(uint160(value))));
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(AddressSet storage set, address value) internal view returns (bool) {
        return _contains(set._inner, bytes32(uint256(uint160(value))));
    }

    /**
     * @dev Returns the number of values in the set. O(1).
     */
    function length(AddressSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

    /**
     * @dev Returns the value stored at position `index` in the set. O(1).
     *
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function at(AddressSet storage set, uint256 index) internal view returns (address) {
        return address(uint160(uint256(_at(set._inner, index))));
    }

    /**
     * @dev Return the entire set in an array
     *
     * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
     * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
     * this function has an unbounded cost, and using it as part of a state-changing function may render the function
     * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
     */
    function values(AddressSet storage set) internal view returns (address[] memory) {
        bytes32[] memory store = _values(set._inner);
        address[] memory result;

        /// @solidity memory-safe-assembly
        assembly {
            result := store
        }

        return result;
    }

    // UintSet

    struct UintSet {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(UintSet storage set, uint256 value) internal returns (bool) {
        return _add(set._inner, bytes32(value));
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(UintSet storage set, uint256 value) internal returns (bool) {
        return _remove(set._inner, bytes32(value));
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(UintSet storage set, uint256 value) internal view returns (bool) {
        return _contains(set._inner, bytes32(value));
    }

    /**
     * @dev Returns the number of values in the set. O(1).
     */
    function length(UintSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

    /**
     * @dev Returns the value stored at position `index` in the set. O(1).
     *
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function at(UintSet storage set, uint256 index) internal view returns (uint256) {
        return uint256(_at(set._inner, index));
    }

    /**
     * @dev Return the entire set in an array
     *
     * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
     * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
     * this function has an unbounded cost, and using it as part of a state-changing function may render the function
     * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
     */
    function values(UintSet storage set) internal view returns (uint256[] memory) {
        bytes32[] memory store = _values(set._inner);
        uint256[] memory result;

        /// @solidity memory-safe-assembly
        assembly {
            result := store
        }

        return result;
    }
}


// File src/slot/auth/AuthSlot.sol

// Original license: SPDX_License_Identifier: MIT
pragma solidity ^0.8.19;
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


// File src/library/ConversionLibrary.sol

// Original license: SPDX_License_Identifier: MIT
pragma solidity ^0.8.0;

/**
* Decimal Representation
*   example:
*       r10 => 10 decimals
*       r11 => 11 decimals
*       r12 => 12 decimals
*
 */
library ConversionLibrary {
    using ConversionLibrary for uint256;

    /**
    * ? decimals => ? decimals
    *
     */
    function toR(uint256 number, uint8 oldDecimals, uint8 newDecimals) internal pure returns (uint256 r) {
        return number
            .fromRToR18(oldDecimals)
            .fromR18ToR(newDecimals);
    }

    /**
    * 18 decimals => ? decimals
    *
     */
    function fromR18ToR(uint256 number, uint8 oldDecimals) internal pure returns (uint256 r) {
        return ((number * (10 ** 18) / (10 ** 18)) * (10 ** oldDecimals)) / (10 ** 18);
    }

    /**
    * ? decimals => 18 decimals
    *
     */
    function fromRToR18(uint256 number, uint8 oldDecimals) internal pure returns (uint256 r18) {
        return ((number * (10 ** 18) / (10 ** oldDecimals)) * (10 ** 18)) / (10 ** 18);
    }
}


// File src/non-native/uniswap/interfaces/IUniswapV2Factory.sol

// Original license: SPDX_License_Identifier: MIT
pragma solidity ^0.8.0;

interface IUniswapV2Factory {
    event PairCreated(
        address indexed token0,
        address indexed token1,
        address pair,
        uint256
    );

    function feeTo() external view returns (address);

    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB)
        external
        view
        returns (address pair);

    function allPairs(uint256) external view returns (address pair);

    function allPairsLength() external view returns (uint256);

    function createPair(address tokenA, address tokenB)
        external
        returns (address pair);

    function setFeeTo(address) external;

    function setFeeToSetter(address) external;
}


// File src/non-native/uniswap/interfaces/IUniswapV2Pair.sol

// Original license: SPDX_License_Identifier: MIT
pragma solidity ^0.8.0;

interface IUniswapV2Pair {
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
    event Transfer(address indexed from, address indexed to, uint256 value);

    function name() external pure returns (string memory);

    function symbol() external pure returns (string memory);

    function decimals() external pure returns (uint8);

    function totalSupply() external view returns (uint256);

    function balanceOf(address owner) external view returns (uint256);

    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    function approve(address spender, uint256 value) external returns (bool);

    function transfer(address to, uint256 value) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);

    function PERMIT_TYPEHASH() external pure returns (bytes32);

    function nonces(address owner) external view returns (uint256);

    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    event Mint(address indexed sender, uint256 amount0, uint256 amount1);
    event Burn(
        address indexed sender,
        uint256 amount0,
        uint256 amount1,
        address indexed to
    );
    event Swap(
        address indexed sender,
        uint256 amount0In,
        uint256 amount1In,
        uint256 amount0Out,
        uint256 amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint256);

    function factory() external view returns (address);

    function token0() external view returns (address);

    function token1() external view returns (address);

    function getReserves()
        external
        view
        returns (
            uint112 reserve0,
            uint112 reserve1,
            uint32 blockTimestampLast
        );

    function price0CumulativeLast() external view returns (uint256);

    function price1CumulativeLast() external view returns (uint256);

    function kLast() external view returns (uint256);

    function mint(address to) external returns (uint256 liquidity);

    function burn(address to)
        external
        returns (uint256 amount0, uint256 amount1);

    function swap(
        uint256 amount0Out,
        uint256 amount1Out,
        address to,
        bytes calldata data
    ) external;

    function skim(address to) external;

    function sync() external;

    function initialize(address, address) external;
}


// File src/non-native/uniswap/interfaces/IUniswapV2Router01.sol

// Original license: SPDX_License_Identifier: MIT
pragma solidity 0.8.19;

interface IUniswapV2Router01 {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    )
        external
        returns (
            uint256 amountA,
            uint256 amountB,
            uint256 liquidity
        );

    function addLiquidityETH(
        address token,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    )
        external
        payable
        returns (
            uint256 amountToken,
            uint256 amountETH,
            uint256 liquidity
        );

    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityETH(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountToken, uint256 amountETH);

    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityETHWithPermit(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountToken, uint256 amountETH);

    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapTokensForExactTokens(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactETHForTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function swapTokensForExactETH(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactTokensForETH(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapETHForExactTokens(
        uint256 amountOut,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function quote(
        uint256 amountA,
        uint256 reserveA,
        uint256 reserveB
    ) external pure returns (uint256 amountB);

    function getAmountOut(
        uint256 amountIn,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountOut);

    function getAmountIn(
        uint256 amountOut,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountIn);

    function getAmountsOut(uint256 amountIn, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);

    function getAmountsIn(uint256 amountOut, address[] calldata path)
        external
        view
        returns (uint256[] memory amounts);
}


// File src/non-native/uniswap/interfaces/IUniswapV2Router02.sol

// Original license: SPDX_License_Identifier: MIT
pragma solidity ^0.8.0;
interface IUniswapV2Router02 is IUniswapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountETH);

    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable;

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;
}


// File src/library/PairLibrary.sol

// Original license: SPDX_License_Identifier: MIT
pragma solidity ^0.8.0;
library PairLibrary {
    using PairLibrary for address[];
    using ConversionLibrary for uint256;
    
    function token0(address[] memory pair) internal pure returns (address) {
        return pair[0];
    }

    function token1(address[] memory pair) internal pure returns (address) {
        return pair[pair.length - 1];
    }

    function decimals0(address[] memory pair) internal view returns (uint8) {
        return IToken(pair.token0()).decimals();
    }

    function decimals1(address[] memory pair) internal view returns (uint8) {
        return IToken(pair.token1()).decimals();
    }

    function toInterface(address[] memory pair, IUniswapV2Factory uniswapV2Factory) internal view returns (IUniswapV2Pair) {
        return IUniswapV2Pair(pair.toAddress(uniswapV2Factory));
    }

    function toAddress(address[] memory pair, IUniswapV2Factory uniswapV2Factory) internal view returns (address) {
        return uniswapV2Factory.getPair(pair.token0(), pair.token1());
    }

    function reserves(address[] memory pair, IUniswapV2Factory uniswapV2Factory) internal view returns (uint256[] memory) {
        uint256[] memory reserve = new uint256[](2);
        (reserve[0], reserve[1],) = pair
            .toInterface(uniswapV2Factory)
            .getReserves();
        return reserve;
    }

    function isZeroAddress(address[] memory pair, IUniswapV2Factory uniswapV2Factory) internal view returns (bool) {
        return pair.toAddress(uniswapV2Factory) == address(0);
    }

    function isSameLayout(address[] memory pair, IUniswapV2Factory uniswapV2Factory) internal view returns (bool) {
        return pair.token0() == pair.toInterface(uniswapV2Factory).token0();
    }

    function price(address[] memory pair, IUniswapV2Factory uniswapV2Factory, IUniswapV2Router02 uniswapV2Router02) internal view returns (uint256 r18) {
        if (pair.isZeroAddress(uniswapV2Factory)) {
            return 0;
        }
        if (pair.isSameLayout(uniswapV2Factory)) {
            return uniswapV2Router02
                .quote(
                    10 ** pair.decimals0(),
                    pair.reserves(uniswapV2Factory)[0],
                    pair.reserves(uniswapV2Factory)[1]
                )
                .fromRToR18(pair.decimals1());
        }
        return uniswapV2Router02
            .quote(
                10 ** pair.decimals1(),
                pair.reserves(uniswapV2Factory)[1],
                pair.reserves(uniswapV2Factory)[0]
            )
            .fromRToR18(pair.decimals1());
    }

    function amountOut(address[] memory pair, IUniswapV2Factory uniswapV2Factory, IUniswapV2Router02 uniswapV2Router02) internal view returns (uint256 r18) {
        if (pair.isZeroAddress(uniswapV2Factory)) {
            return 0;
        }
        if (pair.isSameLayout(uniswapV2Factory)) {
            return uniswapV2Router02
                .getAmountOut(
                    10 ** pair.decimals0(),
                    pair.reserves(uniswapV2Factory)[0],
                    pair.reserves(uniswapV2Factory)[1]
                )
                .fromRToR18(pair.decimals1());
        }
        return uniswapV2Router02
            .getAmountOut(
                10 ** pair.decimals1(),
                pair.reserves(uniswapV2Factory)[1],
                pair.reserves(uniswapV2Factory)[0]
            )
            .fromRToR18(pair.decimals1());
    }

    function amountOut(address[] memory path, IUniswapV2Factory uniswapV2Factory, IUniswapV2Router02 uniswapV2Router02, uint256 r18AmountIn) internal view returns (uint256 r18) {
        uint256[] memory amounts = uniswapV2Router02
            .getAmountsOut(
                r18AmountIn.fromR18ToR(path.decimals0()),
                path
            );
        return amounts[amounts.length - 1]
            .fromRToR18(path.decimals1());
    }

    function minAmountOut(address[] memory path, IUniswapV2Factory uniswapV2Factory, IUniswapV2Router02 uniswapV2Router02, uint256 r18AmountIn, uint8 swapThreshold) internal view returns (uint256 r18) {
        uint256 r18AmountOut = path
            .amountOut(
                uniswapV2Factory, 
                uniswapV2Router02, 
                r18AmountIn);
        uint256 r18AcceptableLoss = ((r18AmountOut
            .fromR18ToR(100) / 10000) * swapThreshold)
            .fromRToR18(100);
        return r18AmountOut - r18AcceptableLoss;
    }

    function swap(address[] memory path, IUniswapV2Factory uniswapV2Factory, IUniswapV2Router02 uniswapV2Router02, uint256 r18AmountIn, uint8 swapThreshold) internal returns (uint256 r18) {
        IERC20 tokenIn = IERC20(path.token0());
        tokenIn
            .approve(address(uniswapV2Router02), 0);
        tokenIn
            .approve(address(uniswapV2Router02), r18AmountIn);
        uint256[] memory amounts = uniswapV2Router02
            .swapExactTokensForTokens(
                r18AmountIn
                    .fromR18ToR(
                        path.decimals0()),
                path
                    .minAmountOut(
                        uniswapV2Factory, 
                        uniswapV2Router02, 
                        r18AmountIn, 
                        swapThreshold),
                path,
                msg.sender,
                block.timestamp
            );
        tokenIn.approve(address(uniswapV2Router02), 0);
        return amounts[amounts.length - 1]
            .fromRToR18(path.decimals1());
    }
}


// File src/slot/market/PaletteSlot.sol

// Original license: SPDX_License_Identifier: MIT
pragma solidity ^0.8.19;
/**
* NOTE Supporting an infinite amount of tokens is not possible because
*      every token must have their value, price, and other operations
*      calculated for them. The token palette allows us to enforce a
*      selected number of tokens that can be supported, this number
*      is low enough that it will not cause a operation to be
*      unaffordable.
*
 */
library PaletteSlotLib {
    using EnumerableSet for EnumerableSet.AddressSet;

    event AddedTokenToPalette(address token);
    event RemovedTokenFromPalette(address token);

    struct Palette {
        EnumerableSet.AddressSet __tokens;
    }

    function maximumTokensLength() internal pure returns (uint256) {
        return 32;
    }

    function requireTokenInPalette(Palette storage palette, address token) internal view returns (Palette storage) {
        require(hasToken(palette, token), 'Palette: is not a token on the palette');
        return palette;
    }

    function requireTokensLengthWillBeWithinRange(Palette storage palette) internal view returns (Palette storage) {
        require(tokensLength(palette) < maximumTokensLength(), 'Palette: cannot support any more tokens');
        return palette;
    }

    function tokens(Palette storage palette) internal view returns (address[] memory) {
        return palette.__tokens.values();
    }

    function tokensLength(Palette storage palette) internal view returns (uint256) {
        return palette.__tokens.length();
    }

    function hasToken(Palette storage palette, address token) internal view returns (bool) {
        return palette.__tokens.contains(token);
    }

    function addToken(Palette storage palette, address token) internal returns (Palette storage) {
        requireTokensLengthWillBeWithinRange(palette);
        palette.__tokens.add(token);
        emit AddedTokenToPalette(token);
        return palette;
    }

    /**
    * NOTE If a token still has a balance in the vault and it is removed
    *      this function will not check. Separate logic must be built to
    *      handle this scenario.
    *
     */
    function removeToken(Palette storage palette, address token) internal returns (Palette storage) {
        palette.__tokens.remove(token);
        emit RemovedTokenFromPalette(token);
        return palette;
    }
}

contract PaletteSlot {
    bytes32 constant internal PALETTE = bytes32(uint256(keccak256('eip1967.PALETTE')) - 1);

    function palette() internal pure returns (PaletteSlotLib.Palette storage sl) {
        bytes32 location = PALETTE;
        assembly {
            sl.slot := location
        }
    }
}


// File src/slot/market/MarketSlot.sol

// Original license: SPDX_License_Identifier: MIT
pragma solidity ^0.8.19;
/**
* NOTE The market is compatible with the v2 uniswap interface. It is
*      important that during construction the name, factory, and router
*      point to the correct exchange.
*
* NOTE The denominator will determine what pairs can be traded with.
*
* NOTE Supports buy and sell to denominator, routed swaps are not supported.
*
* Constructor Instructions
*
*   1. set name
*   2. set factory
*   3. set router
*   4. set denominator
 */
library MarketSlotLib {
    using PaletteSlotLib for PaletteSlotLib.Palette;

    event ChangedMarketName(string indexed name);
    event ChangedMarketFactory(address indexed factory);
    event ChangedMarketRouter(address indexed router);
    event ChangedMarketDenominator(address indexed denominator);
    event Bought(address indexed token);
    event Sold(address indexed token);

    struct Market {
        string __name;
        address __factory;
        address __router;
        address __denominator;
    }

    function name(Market storage market) internal view returns (string memory) {
        return market.__name;
    }

    /**
    * NOTE UniswapV2Factory
    *
     */
    function factory(Market storage market) internal view returns (address) {
        return market.__factory;
    }

    /**
    * NOTE UniswapV2Router02
    *
     */
    function router(Market storage market) internal view returns (address) {
        return market.__router;
    }

    /**
    * NOTE The denominator is the token contract that the market will exchange
    *      to and from. It is important to pick a denominator that has good
    *      liquidity and support to maximize the amount of pairs available.
    *
     */
    function denominator(Market storage market) internal view returns (address) {
        return market.__denominator;
    }

    function price(Market storage market, address token) internal view returns (uint256 r18) {
        address[] memory pair = address[](2);
        pair[0] = token;
        pair[1] = denominator(market);
        return pair.price(IUniswapV2Factory(factory(market)), IUniswapV2Router02(router(market)));
    }

    function amountOut(Market storage market, address token, uint256 amountR18) internal view returns (uint256 r18) {
        address[] memory pair = address[](2);
        pair[0] = token;
        pair[1] = denominator(market);
        return pair.amountOut(IUniswapV2Factory(factory(market)), IUniswapV2Router02(router(market)), amountR18);
    }

    function setName(Market storage market, string memory name) internal returns (Market storage) {
        market.__name = name;
        emit ChangedMarketName(name);
        return market;
    }

    function setFactory(Market storage market, address factory) internal returns (Market storage) {
        market.__factory = factory;
        emit ChangedMarketFactory(factory);
        return market;
    }

    function setRouter(Market storage market, address router) internal returns (Market storage) {
        market.__router = router;
        emit ChangedMarketRouter(router);
        return market;
    }

    function setDenominator(Market storage market, address denominator) internal returns (Market storage) {
        market.__denominator = denominator;
        emit ChangedMarketDenominator(denominator);
        return market;
    }

    function buy(Market storage market, address token, uint256 amountR18) internal returns (uint256 r18) {
        address[] memory pair = address[](2);
        pair[0] = denominator(market);
        pair[1] = token;
        emit Bought(token);
        return pair.swap(IUniswapV2Factory(factory(market)), IUniswapV2Router02(router(market)), amountR18, 200);
    }

    function sell(Market storage market, address token, uint256 amountR18) internal returns (uint256 r18) {
        address[] memory pair = address[](2);
        pair[0] = token;
        pair[1] = denominator(market);
        emit Sold(token);
        return pair.swap(IUniswapV2Factory(factory(market)), IUniswapV2Router02(router(market)), amountR18, 200);
    }
}

contract MarketSlot {
    bytes32 constant internal MARKET = bytes32(uint256(keccak256('eip1967.MARKET')) - 1);

    function market() internal pure returns (MarketSlotLib.Market storage sl) {
        bytes32 location = MARKET;
        assembly {
            sl.slot := location
        }
    }
}


// File src/console/Vault/ClaimConsole.sol

// Original license: SPDX_License_Identifier: MIT
pragma solidity ^0.8.19;
contract ClaimConsole is AuthSlot, TokenSlot, MarketSlot {
    using AuthSlotLib for AuthSlotLib.Auth;
    using TokenSlotLib for TokenSlotLib.Token;
    using MarketSlotLib for MarketSlotLib.Market;

    function selectors() external returns (bytes4[] memory response) {
        response = bytes4[](1);
        response[0] = bytes4(keccak256('claimOwnership(string,string)'));
        return response;
    }

    /**
    * Polygon Quickswap
    *    UniswapV2Factory    => 0x5757371414417b8C6CAad45bAeF941aBc7d3Ab32
    *    UniswapV2Router02   => 0xa5E0829CaCEd8fFDD4De3c43696c57F7D7A678ff
    *    WMATIC              => 0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270
    *
     */
    function claimOwnership(string memory name, string memory symbol, uint256 amountIn) external returns (bool) {
        require(amountIn != 0, 'ClaimConsole: the amount in must not be zero for operations');
        auth().claimOwnership();
        token()
            .setName(name)
            .setSymbol(symbol);
        market()
            .setName('quickswap')
            .setFactory(0x5757371414417b8C6CAad45bAeF941aBc7d3Ab32)
            .setRouter(0xa5E0829CaCEd8fFDD4De3c43696c57F7D7A678ff)
            .setDenominator(0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270);
        IToken(market.denominator()).transferFrom(msg.sender, address(this), amountIn);
        token.mint(address(this), 1000000_000000000000000000);
        return true;
    }
}
