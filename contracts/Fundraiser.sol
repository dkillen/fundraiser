// SPDX-License-Identifier: MIT
pragma solidity ^0.7.4;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";

// Fundraiser contract provides a set of functions representing a campaign
// of fundraising allowing donors to make donations and retreive information
// about their donations. The contract also provides methods for the management
// of the campaign by a custodian (the person/entity managing the campaign on
// behalf of the beneficiary) and to eventually withdraw the donated funds
// periodically or when the campaign is at an end.
contract Fundraiser is Ownable {
    using SafeMath for uint256;

    // Struct to represent a donation made by a donor.
    struct Donation {
        uint256 value;
        uint256 date;
    }
    
    // Propertis representing the details of the fundraising campaign

    // name: the name of the campaign
    string public name;
    // url: the url of a website for the campaign
    string public url;
    // imageUrl: url of an image to represent the campaign
    string public imageUrl;
    // description: a description of the campaign which might include the reasons for
    //              the campaign and what the funds will be used for.
    string public description;
    // beneficiary: the address of the beneficiary of the campaign - the person/entity
    //              that the funds are being raised for.
    address payable public beneficiary;
    // totalDonations: the total amount of the donations received by the campaign
    uint256 public totalDonations;
    // donationsCount: the total number of donations received by the campaign
    uint256 public donationsCount;

    // Mapping of donors to donations made. Each donor may have multiple donations.
    mapping(address => Donation[]) private _donations;

    // Events
    event DonationReceived(address indexed donor, uint256 value);
    event Withdraw(uint256 amount);

    // Contructor initialises the contract with the fundraising campaign details
    // and transfers ownership of the contract to the custodian. The custodian would 
    // normally be the person managing the fundraising campaign for the beneficiary.
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

    // Withdraw the funds donated to the campaign. On withdrawal the
    // total funds are transferred to the beneficiary's address
    function withdraw() public onlyOwner {
        uint256 balance = address(this).balance;
        beneficiary.transfer(balance);
        emit Withdraw(balance);
    }

    // receive function to accept transfer sent to the contract address
    // rather than using the donate function
    receive() external payable {
        totalDonations = totalDonations.add(msg.value);
        donationsCount++;
    }
}