// Get funds from users
// Withdraw funds
// Set a minimum funding value in USD
// Keep track of funders

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

import "./PriceConverter.sol"

contract FundMe {

    using PriceConverter for uint256;
    
    // declaring minimun required amount in USD
    uint public minUsd = 50;

    address[] public funders;
    mapping(address => uint256) public addressToAmount

    function fund() public payable {
        require(msg.value.getConversionRate() >= minUsd, "Funding amount must be at least $50");
        funders.push(msg.sender);
        addressToAmount[msg.sender] = msg.value;
    }


}

