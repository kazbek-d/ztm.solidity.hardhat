// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

import {console} from "hardhat/console.sol";
import {ERC20} from "./ERC20.sol";
import {DepositorCoin} from "./DepositorCoin.sol";

contract Stablecoin is ERC20 {
    DepositorCoin public depositorCoin;

    constructor(
        string memory _name,
        string memory _symbol
    ) ERC20(_name, _symbol, 18) {}

    function mint() external payable {
        // TODO: should be real price
        uint256 ethUsdPrice = 1000;

        uint256 mintStablecoinAmount = msg.value * ethUsdPrice;
        _mint(msg.sender, mintStablecoinAmount);
    }

    function burn(uint256 burnStablecoinAmount) external {
        _burn(msg.sender, burnStablecoinAmount);

        // TODO: should be real price
        uint256 ethUsdPrice = 1000;
        uint256 refundingEth = burnStablecoinAmount / ethUsdPrice;

        (bool success, ) = msg.sender.call{value: refundingEth}("");
        require(success, "STC: Burn refund transaction failed");
    }
}
