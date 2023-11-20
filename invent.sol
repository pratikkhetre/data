// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

contract ProductInventory {
    address public owner;
    mapping(string => uint256) public stock;
    string[] public products;

    event ProductReceived(string productName, uint256 quantity);
    event ProductSold(string productName, uint256 quantity);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only contract owner can perform this operation");
        _;
    }

    constructor() public {
        owner = msg.sender;
    }

    function receiveProduct(string memory productName, uint256 quantity) public onlyOwner {
        if (stock[productName] == 0) {
            products.push(productName);
        }
        stock[productName] += quantity;
        emit ProductReceived(productName, quantity);
    }

    function sellProduct(string memory productName, uint256 quantity) public onlyOwner {
        require(stock[productName] >= quantity, "Insufficient stock");

        stock[productName] -= quantity;
        emit ProductSold(productName, quantity);
    }

    

    function getProductCount() public view returns (uint256) {
        return products.length;
    }

    function displayAllStock() public view onlyOwner returns (string[] memory, uint256[] memory) {
        uint256 length = products.length;
        uint256[] memory quantities = new uint256[](length);

        for (uint256 i = 0; i < length; i++) {
            quantities[i] = stock[products[i]];
        }

        return (products, quantities);
    }
}
