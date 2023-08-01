// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    // Retrieves the latest ETH/USD price from the price feed
    function getPrice(AggregatorV3Interface priceFeed) internal view returns (uint256) {
        (, int256 answer,,,) = priceFeed.latestRoundData();
        // ETH/USD rate in 18 decimal places
        return uint256(answer * 10000000000);
    }
    // Converts the given amount of ETH to USD based on the ETH/USD price feed

    function getConversionRate(uint256 ethAmount, AggregatorV3Interface priceFeed) internal view returns (uint256) {
        uint256 ethPrice = getPrice(priceFeed);
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1000000000000000000;
        // Returns the actual ETH/USD conversion rate, after adjusting the extra 0s
        return ethAmountInUsd;
    }
}
