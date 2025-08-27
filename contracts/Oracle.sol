// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

// TODO: Need to create or reuse the Oracle
// reuse: for example this one https://chain.link
contract Oracle {
    uint256 private price = 1000;
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function getPrice() external view returns (uint256) {
        return price;
    }

    function setPrice(uint256 newPrice) external {
        require(msg.sender == owner, "EthUsdPrice: only owner can set price");
        price = newPrice;
    }
}
