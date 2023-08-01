// pragma solidity ^0.8.18;
// import {Script,console} from "forge-std/Script.sol";
// import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
// import {FundMe} from "../src/FundMe.sol";

// contract FundFundMe is Script {
//     uint256 constant SEND_VALUE = 10000 ether;
//     address  USER = makeAddr("user2");
//     uint256 STARTING_BALANCE = 100000000000 ether;
//     // Helper function to get the most recent deployment address as address payable
//     function getPayableDeploymentAddress(string memory contractName) public  returns(address payable){
//         address nonPayableAddr = DevOpsTools.get_most_recent_deployment(contractName, block.chainid);
//         return payable(nonPayableAddr);
//     }

//     function fundFundMe(address payable mostRecentlyDeployed) public payable {
//         FundMe(mostRecentlyDeployed).fund{value:SEND_VALUE}();
//         console.log("funded fund me with %s",SEND_VALUE);
//     }

//     function run() external {
//         vm.deal(USER,STARTING_BALANCE);
//         address payable contractAddress = getPayableDeploymentAddress("FundMe");
//         vm.startBroadcast();
//         vm.prank(USER);
//         fundFundMe(contractAddress);
//         vm.stopBroadcast();
//     }
// }

// contract WithdrawFundMe is Script {
//     uint256 constant SEND_VALUE = 1 ether;

//     // Helper function to get the most recent deployment address as address payable
//     function getPayableDeploymentAddress(string memory contractName) public  returns(address payable){
//         address nonPayableAddr = DevOpsTools.get_most_recent_deployment(contractName, block.chainid);
//         return payable(nonPayableAddr);
//     }

//     function withdrawFundMe(address payable mostRecentlyDeployed) public  {
//         FundMe(mostRecentlyDeployed).withdraw();
//         console.log("funded fund me with %s",SEND_VALUE);
//     }

//     function run() external {
//         address payable contractAddress = getPayableDeploymentAddress("FundMe");
//         vm.startBroadcast();
//         withdrawFundMe(contractAddress);
//         vm.stopBroadcast();
//     }
// }

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundFundMe is Script {
    uint256 constant SEND_VALUE = 10000 ether;
    address USER = makeAddr("user2");
    uint256 STARTING_BALANCE = 100000000000 ether;

    function fundFundMe(address payable contractAddress) public payable {
        FundMe(contractAddress).fund{value: SEND_VALUE}();
        console.log("Funded FundMe with %s", SEND_VALUE);
    }

    function run(address payable contractAddress) external {
        vm.deal(USER, STARTING_BALANCE);
        vm.startBroadcast();
        vm.prank(USER);
        fundFundMe(contractAddress);
        vm.stopBroadcast();
    }
}

contract WithdrawFundMe is Script {
    uint256 constant SEND_VALUE = 1 ether;

    function withdrawFundMe(address payable contractAddress) public {
        FundMe(contractAddress).withdraw();
        console.log("FundMe was withdrawn %s", SEND_VALUE);
    }

    function run(address payable contractAddress) external {
        vm.startBroadcast();
        withdrawFundMe(contractAddress);
        vm.stopBroadcast();
    }
}
