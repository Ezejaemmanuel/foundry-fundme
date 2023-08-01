// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
// Import Test library from Forge

import {Test} from "forge-std/Test.sol";
// Import FundMe contract
import {FundMe} from "../../src/FundMe.sol";
// Import script that deploys FundMe
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

// Create test contract that inherits from Test
contract FundMeTest is Test {
    // Declare FundMe instance
    FundMe fundMe;
    // Declare DeployFundMe instance
    DeployFundMe deployFundMe;
    uint256 constant GAS_PRICE = 1;
    // Constant for ETH send amount in tests
    uint256 constant SEND_VALUE = 1 ether;
    // Declare user address
    address USER = makeAddr("user");
    // Starting ETH balance for user
    uint256 constant STARTING_BALANCE = 10000000 ether;

    // Setup contract before each test
    function setUp() external {
        // Deploy FundMe
        deployFundMe = new DeployFundMe();
        // Fund user address
        fundMe = deployFundMe.run();
        vm.deal(USER, STARTING_BALANCE);
    }

    // Test minimum USD amount
    function testMinimumDemoIs5() public {
        // Assert expected amount
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    // Test owner is msg.sender
    function testOwnerIsMsgSender() public {
        // Assert owner is msg.sender
        assertEq(fundMe.owner(), msg.sender);
    }

    // Test getVersion()
    function testGetVersionIsWorking() public {
        // Call getVersion()
        uint256 version = fundMe.getVersion();
        // Assert expected version
        assertEq(version, 4);
    }

    // Test fund() revert for low amount
    function testIfFundFailedForLowFund() public {
        // Expect revert
        vm.expectRevert();
        // Try to fund less than minimum
        fundMe.fund();
    }

    // Test fund() updates state
    function testFundUpdatesFundedDataStructure() public funded {
        // Get amount funded for user
        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
        // Assert amount funded
        assertEq(amountFunded, SEND_VALUE);
    }

    // Test funders array updated
    function testForArrayOfFundersIsUpdated() public funded {
        // Get funder from array
        address addressOfFunder = fundMe.getFunder(0);
        // Assert addresses match
        assertEq(addressOfFunder, USER);
    }

    // Test only owner can withdraw
    function testIfOnlyOnwerIsWorking() public funded {
        // Withdraw as user
        vm.prank(USER);
        // Expect revert
        vm.expectRevert();
        // Try withdraw as user
        fundMe.withdraw();
    }

    // Modifier to fund contract
    modifier funded() {
        // Fund as user
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        // Continue test
        _;
    }

    // Test successful withdraw
    function testWithdrawISworkingAndIsByASingleUser() public funded {
        // Get starting balances
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;
        // Withdraw as owner
        uint256 gasStart = gasleft();
        vm.txGasPrice(GAS_PRICE);
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();
        uint256 gasEnd = gasleft();
        uint256 gasUsed = (gasStart - gasEnd);
        // Get ending balances
        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;
        // Assert contract balance 0
        assertEq(endingFundMeBalance, 0);
        // Assert owner received funds
        assertEq(startingFundMeBalance + startingOwnerBalance, endingOwnerBalance);
    }

    function testWithdrawFromMultipleFunders() public funded {
        uint160 numberOfFunders = 30;
        uint160 startingFunderIndex = 1;
        for (uint160 i = startingFunderIndex; i < numberOfFunders; i++) {
            hoax(address(i), STARTING_BALANCE);
            fundMe.fund{value: SEND_VALUE}();
        }
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundersBalance = address(fundMe).balance;
        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw();
        vm.stopPrank();
        assertEq(address(fundMe).balance, 0);
        assertEq(startingFundersBalance + startingOwnerBalance, fundMe.getOwner().balance);
    }

    function testWithdrawISworkingAndIsByASingleUser_cheaper() public funded {
        // Get starting balances
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;
        // Withdraw as owner
        uint256 gasStart = gasleft();
        vm.txGasPrice(GAS_PRICE);
        vm.prank(fundMe.getOwner());
        fundMe.cheaperWithdraw();
        uint256 gasEnd = gasleft();
        uint256 gasUsed = (gasStart - gasEnd);
        // Get ending balances
        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;
        // Assert contract balance 0
        assertEq(endingFundMeBalance, 0);
        // Assert owner received funds
        assertEq(startingFundMeBalance + startingOwnerBalance, endingOwnerBalance);
    }

    function testWithdrawFromMultipleFunders_cheaper() public funded {
        uint160 numberOfFunders = 30;
        uint160 startingFunderIndex = 1;
        for (uint160 i = startingFunderIndex; i < numberOfFunders; i++) {
            hoax(address(i), STARTING_BALANCE);
            fundMe.fund{value: SEND_VALUE}();
        }
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundersBalance = address(fundMe).balance;
        vm.startPrank(fundMe.getOwner());
        fundMe.cheaperWithdraw();
        vm.stopPrank();
        assertEq(address(fundMe).balance, 0);
        assertEq(startingFundersBalance + startingOwnerBalance, fundMe.getOwner().balance);
    }
}
