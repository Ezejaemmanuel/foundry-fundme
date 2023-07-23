// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./PriceConverter.sol";
error FundMe__NotOwner();
contract FundMe {
    using PriceConverter for uint256;
     // Mapping to track the amount funded by each address
    mapping(address => uint256) public addressToAmountFunded;
     // Array to store the addresses of funders
    address[] public funders;
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
        require(
            msg.value.getConversionRate(priceFeed) >= MINIMUM_USD,
            "You need to spend more ETH!"
        );
        addressToAmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender);
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
        require(
            msg.sender == owner,
            "Only the contract owner can call this function"
        );
        _;
    }
    /**
     * @dev Function to withdraw all the funds from the contract.
     * Only the contract owner can call this function.
     */
    function withdraw() public onlyOwner {
        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0);
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
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
}