// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;
import {Script} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is Script {
    // Function to deploy FundMe contract
    function run() external returns (FundMe) {
        HelperConfig helperConfig = new HelperConfig();
        address activeNetworkConfig = helperConfig.activeNetworkConfig();

        // Start broadcast
        vm.startBroadcast();
        // Deploy FundMe contract with the specified address
        FundMe fundMe = new FundMe(activeNetworkConfig);
        // Stop broadcast
        vm.stopBroadcast();

        return fundMe;
    }
}
