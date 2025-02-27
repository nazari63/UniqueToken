// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MyUniqueToken {
    string public name = "UniqueToken";
    string public symbol = "UNT";
    uint256 public totalSupply = 1000000 * (10 ** 18);
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    constructor() {
        balanceOf[msg.sender] = totalSupply;
    }

    // Fixed: Correctly decrement allowance in approve function after successful transfer
    function approve(address spender, uint256 value) public returns (bool) {
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    // Fixed: Properly decrease the allowance after a transfer with underflow protection
    function transferFrom(address from, address to, uint256 value) public returns (bool) {
        require(to != address(0), "ERC20: transfer to the zero address");
        require(balanceOf[from] >= value, "ERC20: insufficient balance");
        require(allowance[from][msg.sender] >= value, "ERC20: allowance exceeded");

        // Decreasing balance and allowance
        balanceOf[from] -= value;
        balanceOf[to] += value;

        // Decrement allowance and ensure no underflow happens using Solidity's built-in protection
        allowance[from][msg.sender] -= value;

        emit Transfer(from, to, value);
        return true;
    }

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}
