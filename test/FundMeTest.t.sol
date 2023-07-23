// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.19;
import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;
    DeployFundMe deployFundMe;
    bool yes;

    function setUp() external {
        deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
    }

    function testMinimumDemoIs5() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testOwnerIsMsgSender() public {
        console.log(block.chainid);

        assertEq(fundMe.owner(), msg.sender);
    }

    // function testGetVersionIsWorking() public {
    //     uint256 version = fundMe.getVersion();
    //     console.log("this is the version:", 4);
    //     assertEq(version, 4);
    // }
    function testGetVersionIsWorking() public {
        uint256 version = fundMe.getVersion();
        //version = uint256(version); // where _version is hexadecimal version
        console.log("this is the version:", version);
        assertEq(version, 4);
    }
}
