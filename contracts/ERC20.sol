// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

contract ERC20 {
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address spender, uint256 value);

    string public name; // ERC20
    string public symbol; // ERC20
    uint8 public immutable decimals; // 18

    uint256 internal _totalSupply;

    mapping(address => uint256) public balancesOf;
    mapping(address => mapping(address => uint256)) public allowance;

    constructor(string memory _name, string memory _symbol, uint8 _decimals) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) private returns (bool) {
        require(
            balancesOf[from] >= amount,
            "ERC20: Insufficient sender balance"
        );

        emit Transfer(from, to, amount);

        balancesOf[from] -= amount;
        balancesOf[to] += amount;

        return true;
    }

    function transfer(
        address recipient,
        uint256 amount
    ) external returns (bool) {
        return _transfer(msg.sender, recipient, amount);
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool) {
        require(
            allowance[sender][msg.sender] >= amount,
            "ERC20: Insufficient allowance"
        );
        allowance[sender][msg.sender] -= amount;
        emit Approval(sender, msg.sender, allowance[sender][msg.sender]);
        return _transfer(sender, recipient, amount);
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        allowance[msg.sender][spender] += amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function _mint(address to, uint256 amount) internal {
        balancesOf[to] += amount;
        _totalSupply += amount;

        emit Transfer(address(0), to, amount);
    }

    function _burn(address from, uint256 amount) internal {
        balancesOf[from] -= amount;
        _totalSupply -= amount;

        emit Transfer(from, address(0), amount);
    }
}
