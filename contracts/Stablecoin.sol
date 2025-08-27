// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

import {console} from "hardhat/console.sol";
import {ERC20} from "./ERC20.sol";
import {DepositorCoin} from "./DepositorCoin.sol";
import {EthUsdPrice} from "./EthUsdPrice.sol";

contract Stablecoin is ERC20 {
    DepositorCoin public depositorCoin;
    EthUsdPrice public ethUsdPrice;

    constructor(
        string memory _name,
        string memory _symbol,
        EthUsdPrice _ethUsdPrice
    ) ERC20(_name, _symbol, 18) {
        ethUsdPrice = _ethUsdPrice;
    }

    function mint() external payable {
        uint256 mintStablecoinAmount = msg.value * ethUsdPrice.getPrice();
        _mint(msg.sender, mintStablecoinAmount);
    }

    function burn(uint256 burnStablecoinAmount) external {
        _burn(msg.sender, burnStablecoinAmount);

        uint256 refundingEth = burnStablecoinAmount / ethUsdPrice.getPrice();

        (bool success, ) = msg.sender.call{value: refundingEth}("");
        require(success, "STC: Burn refund transaction failed");
    }

    function depositCollateralBuffer() external payable {
        uint256 surplusInUsd = _getSurplusInContractInUsd();
        uint256 usdInDpcPrice = depositorCoin.totalSupply() / surplusInUsd;
        uint256 mindDepositorCoinAmount = msg.value *
            ethUsdPrice.getPrice() *
            usdInDpcPrice;
        depositorCoin.mint(msg.sender, mindDepositorCoinAmount);
    }

    function withdrawCollateralBuffer(
        uint256 burnDepositorCointAmount
    ) external {
        uint256 surplusInUsd = _getSurplusInContractInUsd();
        depositorCoin.burn(msg.sender, burnDepositorCointAmount);

        uint256 usdInDpcPrice = depositorCoin.totalSupply() / surplusInUsd;
        uint256 refundingUsd = burnDepositorCointAmount / usdInDpcPrice;

        uint256 refundingEth = refundingUsd / ethUsdPrice.getPrice();
        (bool success, ) = msg.sender.call{value: refundingEth}("");
        require(success, "STC: Withdraw collateral buffer transaction failed");
    }

    function _getSurplusInContractInUsd() private view returns (uint256) {
        uint256 ethContractBalanceInUsd = (address(this).balance - msg.value) *
            ethUsdPrice.getPrice();
        uint256 totalStableCoinBalanceInUsd = _totalSupply;
        uint256 surplusInUsd = ethContractBalanceInUsd -
            totalStableCoinBalanceInUsd;

        return surplusInUsd;
    }
}
