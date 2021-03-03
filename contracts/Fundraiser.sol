// SPDX-License-Identifier: MIT
pragma solidity ^0.7.4;

import "openzeppelin-solidity/contracts/access/Ownable.sol";
import "openzeppelin-solidity/contracts/math/SafeMath.sol";

contract Fundraiser is Ownable {
    using SafeMath for uint256;

    // Struct to represent a donation made by a donor.
    struct Donation {
        uint256 value;
        uint256 date;
    }

    
    // Details of the fundraising campaign
    string public name;
    string public url;
    string public imageUrl;
    string public description;
    address payable public beneficiary;
    uint256 public totalDonations;
    uint256 public donationsCount;

    // Mapping of donors to donations made. Each donor may have multiple donations.
    mapping(address => Donation[]) private _donations;

    // Events
    event DonationReceived(address indexed donor, uint256 value);

    // Contructor initialises the contract with the fundraising campaign details
    // and transfers ownership of the contract to the custodian. THe custodian is
    // would normally be the person managing the fundraising campaign for the beneficiary.
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

    // Allows the custodian(owner) to change the beneficiary
    function setBeneficiary(address payable _beneficiary) public onlyOwner {
        beneficiary = _beneficiary;
    }

    // Obtain the count of donations made from a particular address 
    function myDonationsCount() public view returns(uint256) {
        return _donations[msg.sender].length;
    }

    // Donate to the fundraising campaign
    function donate() public payable {
        Donation memory donation = Donation({
            value: msg.value,
            date: block.timestamp
        });
        _donations[msg.sender].push(donation);
        totalDonations = totalDonations.add(msg.value);
        donationsCount++;

        emit DonationReceived(msg.sender, msg.value);
    }

    // Allow a donor to retrieve details of the donations made to the campaign
    function myDonations() public view returns(uint256[] memory values, uint256[] memory dates) {
        uint256 count = myDonationsCount();
        values = new uint256[](count);
        dates = new uint256[](count);

        for (uint256 i = 0; i < count; i++) {
            Donation storage donation = _donations[msg.sender][i];
            values[i] = donation.value;
            dates[i] = donation.date;
        }

        return (values, dates);
    }
}