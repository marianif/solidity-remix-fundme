// Get funds from users
// Withdraw funds
// Set a minimum funding value in USD
// Keep track of funders

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

import "./PriceConverter.sol";

contract FundMe {

    using PriceConverter for uint256;
    
    // declaring minimun required amount in USD
    uint public minUsd = 50;

    address[] public funders;
    mapping(address => uint256) public addressToAmount;

    address public owner; 

    // constructor are special functions called when contract is deployed

    constructor(){
        // owner gets initialized with the address of the sender i.e address that deployes the contract
        owner = msg.sender;
    }

    function fund() public payable {
        require(msg.value.getConversionRate() >= minUsd, "Funding amount must be at least $50");
        funders.push(msg.sender);
        addressToAmount[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner {

        for( uint256 index = 0; index < funders.length; index++) {
            address funder = funders[index];
            addressToAmount[funder] = 0;
        }
        // basic solidity array resetting
        funders = new address[](0);

        /* Actually withdraw funds
        - 3 different ways to do this:

        1.transfer
        2.send
        3.call */

        // --- transfer (max 2300 gas, throws error and reverts the transaction)
        //payable(msg.sender).transfer(address(this).balance)

        // --- send ( max 2300 gas, returns bool)
        //bool sendSuccess = payable(msg.sender).send(address(this).balance);
        //require(sendSuccess, "Send Failed");

        // --- call (forward all gas or set gas, returns bool and data returned by called function)

        /* 
        Example calling a function:
        (bool callSuccess, bytes memory dataReturned) = payable(msg.sender).call{value: address(this).balance}("calledFunctionHere")
        */

        // In our scenario, we don't need to call any function
        (bool callSuccess,) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call Failed");
    }

    
        modifier onlyOwner {
         // checks if withdraw is called by the owner
         require(msg.sender == owner, "Only the owner of the contract can withdraw funds!");
         _;
        } 


}

