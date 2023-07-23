// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;
import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/mockV3Aggrevator.sol";

contract HelperConfig is Script {
    // Structure to store network configuration
    struct NetworkConfig {
        address priceFeedAddress;
    }
    // Active network configuration
    NetworkConfig public activeNetworkConfig;
    // Constants
    uint8 public constant DECIMAL = 8;
    int256 public constant INITIAL_ANSWER = 2000e8;

    constructor() {
        // Check the chain ID and set the active network configuration accordingly
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else {
            activeNetworkConfig = getAnvilEthConfig();
        }
    }

    // Returns the configuration for Sepolia ETH network
    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory sepoliaConfig = NetworkConfig({
            priceFeedAddress: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return sepoliaConfig;
    }

    // Returns the configuration for Anvil ETH network
    function getAnvilEthConfig() public returns (NetworkConfig memory) {
        // If the active network configuration already has a price feed address, return it
        if (activeNetworkConfig.priceFeedAddress != address(0)) {
            return activeNetworkConfig;
        }
        // Start the broadcast
        vm.startBroadcast();
        // Create a new mock V3 aggregator with the specified decimal and initial answer
        MockV3Aggregator mockV3Aggregator = new MockV3Aggregator(
            DECIMAL,
            INITIAL_ANSWER
        );
        // Stop the broadcast
        vm.stopBroadcast();
        // Create the Anvil ETH network configuration with the address of the mock V3 aggregator
        NetworkConfig memory anvilConfig = NetworkConfig({
            priceFeedAddress: address(mockV3Aggregator)
        });
        return anvilConfig;
    }
}
