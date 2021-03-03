// SPDX-License-Identifier: MIT
pragma solidity ^0.7.4;

import "openzeppelin-solidity/contracts/access/Ownable.sol";

contract Fundraiser is Ownable {

    string public name;
    string public url;
    string public imageUrl;
    string public description;

    address payable public beneficiary;

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
        transferOwnership(_custodian);
    }

    function setBeneficiary(address payable _beneficiary) public onlyOwner {
        beneficiary = _beneficiary;
    }
}