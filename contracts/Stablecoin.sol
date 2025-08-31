// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

import {console} from "hardhat/console.sol";
import {ERC20} from "./ERC20.sol";
import {DepositorCoin} from "./DepositorCoin.sol";
import {Oracle} from "./Oracle.sol";

contract Stablecoin is ERC20 {
    DepositorCoin public depositorCoin;
    Oracle public oracle;
    uint256 public feeRatePercentage;
    uint256 public initialCollateralRatioPercentage;

    constructor(
        string memory _name,
        string memory _symbol,
        Oracle _oracle,
        uint256 _feeRatePercentage,
        uint256 _initialCollateralRatioPercentage
    ) ERC20(_name, _symbol, 18) {
        oracle = _oracle;
        feeRatePercentage = _feeRatePercentage;
        initialCollateralRatioPercentage = _initialCollateralRatioPercentage;
    }

    function mint() external payable {
        uint256 fee = _getFee(msg.value);
        uint256 mintStablecoinAmount = (msg.value - fee) * oracle.getPrice();
        _mint(msg.sender, mintStablecoinAmount);
    }

    function burn(uint256 burnStablecoinAmount) external {
        _burn(msg.sender, burnStablecoinAmount);

        uint256 refundingEth = burnStablecoinAmount / oracle.getPrice();

        uint256 fee = _getFee(refundingEth);

        (bool success, ) = msg.sender.call{value: (refundingEth - fee)}("");
        require(success, "STC: Burn refund transaction failed");
    }

    function _getFee(uint256 ethAmount) private view returns (uint256) {
        return (ethAmount * feeRatePercentage) / 100;
    }

    function depositCollateralBuffer() external payable {
        int256 deficitOrSurplusInUsd = _getDeficitOrSurplusInContractInUsd();
        uint256 usdInDpcPrice;
        uint256 addedSurplusEth;
        uint256 oracle_getPrice = oracle.getPrice();
        if (deficitOrSurplusInUsd <= 0) {
            uint256 deficitInUsd = uint256(deficitOrSurplusInUsd * -1);
            uint256 deficitInEth = deficitInUsd / oracle_getPrice;

            addedSurplusEth = msg.value - deficitInEth;

            uint256 requiredInitialSurplusInUSD = (initialCollateralRatioPercentage *
                    depositorCoin.totalSupply()) / 100;
            uint256 requiredInitialSurplusInEth = requiredInitialSurplusInUSD /
                oracle.getPrice();

            require(
                addedSurplusEth >= requiredInitialSurplusInEth,
                "STC: Initial collateral ration not met"
            );

            depositorCoin = new DepositorCoin("Depositor Coin", "DPC");
            usdInDpcPrice = 1;
        } else {
            uint256 surplusInUsd = uint256(deficitOrSurplusInUsd);
            addedSurplusEth = msg.value;
            usdInDpcPrice = depositorCoin.totalSupply() / surplusInUsd;
        }

        uint256 mindDepositorCoinAmount = addedSurplusEth *
            oracle_getPrice *
            usdInDpcPrice;
        depositorCoin.mint(msg.sender, mindDepositorCoinAmount);
    }

    function withdrawCollateralBuffer(
        uint256 burnDepositorCointAmount
    ) external {
        int256 deficitOrSurplusInUsd = _getDeficitOrSurplusInContractInUsd();

        require(
            deficitOrSurplusInUsd > 0,
            "STC: No depositor funds to withdraw"
        );

        depositorCoin.burn(msg.sender, burnDepositorCointAmount);

        uint256 surplusInUsd = uint256(deficitOrSurplusInUsd);

        uint256 usdInDpcPrice = depositorCoin.totalSupply() / surplusInUsd;
        uint256 refundingUsd = burnDepositorCointAmount / usdInDpcPrice;

        uint256 refundingEth = refundingUsd / oracle.getPrice();
        (bool success, ) = msg.sender.call{value: refundingEth}("");
        require(success, "STC: Withdraw collateral buffer transaction failed");
    }

    function _getDeficitOrSurplusInContractInUsd()
        private
        view
        returns (int256)
    {
        uint256 ethContractBalanceInUsd = (address(this).balance - msg.value) *
            oracle.getPrice();
        uint256 totalStableCoinBalanceInUsd = _totalSupply;
        int256 surplusOrDeficit = int256(ethContractBalanceInUsd) -
            int256(totalStableCoinBalanceInUsd);

        return surplusOrDeficit;
    }
}
