// SPDX-License-Identifier: MIT
pragma solidity ^0.7.4;

contract Fundraiser {

    string public name;
    string public url;
    string public imageUrl;
    string public description;

    address payable public beneficiary;
    address public custodian;

    constructor(
        string memory _name,
        string memory _url,
        string memory _imageUrl,
        string memory _description,
        address payable _beneficiary,
        address _custodian
    ) {
        name = _name;
        url = _url;
        imageUrl = _imageUrl;
        description = _description;
        beneficiary = _beneficiary;
        custodian = _custodian;
    }
}