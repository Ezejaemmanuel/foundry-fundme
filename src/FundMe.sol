// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConverter.sol";

error FundMe__NotOwner();

contract FundMe {
    using PriceConverter for uint256;
    // Mapping to track the amount funded by each address

    mapping(address => uint256) public s_addressToAmountFunded;
    // Array to store the addresses of funders
    address[] public s_funders;
    // Address of the contract owner
    address public immutable owner;
    // Minimum USD value required for funding
    uint256 public constant MINIMUM_USD = 5 * 10 ** 18;
    // Price feed interface
    AggregatorV3Interface private priceFeed;

    constructor(address priceFeedAddress) {
        owner = msg.sender;
        priceFeed = AggregatorV3Interface(priceFeedAddress);
    }

    /**
     * @dev Function to fund the contract with ETH.
     * The amount of ETH sent must be greater than or equal to the minimum required USD value.
     */
    function fund() public payable {
        require(msg.value.getConversionRate(priceFeed) >= MINIMUM_USD, "You need to spend more ETH!");
        s_addressToAmountFunded[msg.sender] += msg.value;
        s_funders.push(msg.sender);
    }

    /**
     * @dev Function to get the version of the price feed.
     * @return The version of the price feed.
     */
    function getVersion() public view returns (uint256) {
        return priceFeed.version();
    }

    /**
     * @dev Modifier to ensure that only the contract owner can call a function.
     */
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can call this function");
        _;
    }

    /**
     * @dev Function to withdraw all the funds from the contract.
     * Only the contract owner can call this function.
     */

    function cheaperWithdraw() public onlyOwner {
        uint256 fundersLength = s_funders.length;
        for (uint256 i = 0; i < fundersLength; i++) {
            address funder = s_funders[i];
            s_addressToAmountFunded[funder] = 0;
        }

        s_funders = new address[](0);
        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Withdrawal failed");
    }

    function withdraw() public onlyOwner {
        for (uint256 funderIndex = 0; funderIndex < s_funders.length; funderIndex++) {
            address funder = s_funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }
        s_funders = new address[](0);
        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Withdrawal failed");
    }

    /**
     * @dev Fallback function to handle incoming ETH transfers.
     * Automatically calls the fund() function.
     */
    fallback() external payable {
        fund();
    }

    /**
     * @dev Receive function to handle incoming ETH transfers.
     * Automatically calls the fund() function.
     */
    receive() external payable {
        fund();
    }

    //these are the getters/.......
    //this is getting the value of the amount funded by this particular address
    function getAddressToAmountFunded(address fundingAddress) external view returns (uint256) {
        return s_addressToAmountFunded[fundingAddress];
    }

    function getFunder(uint256 index) external view returns (address) {
        return s_funders[index];
    }

    function getOwner() external view returns (address) {
        return owner;
    }
}
