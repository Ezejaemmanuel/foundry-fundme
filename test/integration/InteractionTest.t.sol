// pragma solidity ^0.8.18;
// // Import Test library from Forge
// import {Test,console} from "forge-std/Test.sol";
// // Import FundMe contract
// import {FundMe} from "../../src/FundMe.sol";
// // Import script that deploys FundMe
// import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
// import {FundFundMe,WithdrawFundMe} from  "../../script/interaction.s.sol";
// // Create test contract that inherits from Test

// contract InteractionTest is Test {
// uint256 constant STARTING_BALANCE = 1000000 ether;

//     address USER = makeAddr("user2");
//     FundMe fundMe;
//     function setUp() external {
//         DeployFundMe deployFundMe = new DeployFundMe();
//         fundMe = deployFundMe.run();
//         vm.deal(USER,STARTING_BALANCE);
//     }
//     function testIfUserIsFunded() public {
//         vm.prank(USER);
//         uint256 balance = address(this).balance;
//         uint256 balanceOfUser = USER.balance;
//         console.log("this is the balance of the user",balanceOfUser);
//         console.log("the balance is ",balance);

//     }
//     function  testUserCanFundInteraction() public {
//         console.log("address of user",USER);
//         uint256 balanceOfUser = USER.balance;
//         console.log("this is the balance of the user",balanceOfUser);
//         vm.startPrank(USER);
//         console.log("the balance 1",address(this).balance);
//         vm.prank(USER);
//         FundFundMe fundFundMe = new FundFundMe();
//         console.log("the balance 2",address(fundFundMe).balance);
//         fundFundMe.fundFundMe(payable(address(fundMe)));
//         console.log("the balance 3",address(fundFundMe).balance);
//         WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
//         console.log("the balance 4",address(withdrawFundMe).balance);
//         withdrawFundMe.withdrawFundMe(payable(address(fundMe)));
//         console.log("the balance 4",address(withdrawFundMe).balance);
//         vm.stopPrank();

//         assert(address(fundMe).balance == 0);
//     }
// }// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

// Import Test library from Forge
import {Test, console} from "forge-std/Test.sol";

// Import FundMe contract
import {FundMe} from "../../src/FundMe.sol";

// Import script that deploys FundMe
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/interaction.s.sol";

// Create test contract that inherits from Test
contract InteractionTest is Test {
    uint256 constant STARTING_BALANCE = 1000000 ether;
    address USER = makeAddr("user2");
    FundMe fundMe;

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        hoax(USER, STARTING_BALANCE);
    }

    function testIfUserIsFunded() public {
        hoax(USER);
        uint256 balance = address(this).balance;
        uint256 balanceOfUser = USER.balance;
        console.log("this is the balance of the user", balanceOfUser);
        console.log("the balance is ", balance);
    }

    // function testUserCanFundInteraction() public {
    //     console.log("address of user",USER);
    //     uint256 balanceOfUser = USER.balance;
    //     console.log("this is the balance of the user",balanceOfUser);
    //     hoax(address(this));
    //     console.log("the balance 1",address(this).balance);
    //     FundFundMe fundFundMe = new FundFundMe();
    //     console.log("the balance 2",address(fundFundMe).balance);
    //     hoax(USER);
    //     fundFundMe.fundFundMe(payable(address(fundMe)));
    //     console.log("the balance 3",address(fundFundMe).balance);
    //     WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
    //     console.log("the balance 4",address(withdrawFundMe).balance);
    //     hoax(USER);
    //     withdrawFundMe.withdrawFundMe(payable(address(fundMe)));
    //     console.log("the balance 4",address(withdrawFundMe).balance);
    //     assert(address(fundMe).balance == 0);
    // }
}
