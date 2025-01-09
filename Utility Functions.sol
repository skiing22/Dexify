// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

library DexifyLibrary {
    // Calculate the output amount using constant product formula
    function calculateOutput(
        uint256 inputAmount,
        uint256 inputReserve,
        uint256 outputReserve,
        uint256 fee
    ) internal pure returns (uint256 outputAmount) {
        uint256 inputAmountWithFee = (inputAmount * (10000 - fee)) / 10000;
        uint256 numerator = inputAmountWithFee * outputReserve;
        uint256 denominator = inputReserve + inputAmountWithFee;
        return numerator / denominator;
    }
}
