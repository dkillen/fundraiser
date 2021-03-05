// SPDX-License-Identifier: MIT
pragma solidity ^0.7.4;

import "./Fundraiser.sol";

// FundraiserFactor contract to generate new fundraising campaigns as needed by
// instantiating a new Fundraiser contract the address of which is then stored 
// in a collection of Fundraiser contracts.
contract FundraiserFactory {

    // Collection of Fundraiser contracts to which the address of new contracts
    // will be added once instantiated
    Fundraiser[] private _fundraisers;

    // Events
    event FundraiserCreated(Fundraiser indexed fundraiser, address indexed owner);

    // The maximum number of Fundraiser campaigns that will be returned at any one tim
    uint256 constant maxLimit = 20;

    // Instantiate a new Fundraiser contract and add its address to the _fundraisers collection.
    function createFundraiser(
        string memory name,
        string memory url,
        string memory imageUrl,
        string memory description,
        address payable beneficiary
    ) 
        public 
    {
        Fundraiser fundraiser = new Fundraiser(
            name,
            url,
            imageUrl,
            description,
            beneficiary,
            msg.sender
        );
        _fundraisers.push(fundraiser);
        emit FundraiserCreated(fundraiser, msg.sender);
    }

    // Returns the total number of campaigns in the collection
    function fundraisersCount() public view returns(uint256) {
        return _fundraisers.length;
    }

    // Returns up to limit number of campaigns from the collection but, no more
    // than maxLimit at any one time.
    // Pagination provided by the offset - a set of Fundraiser contract addresses
    // can be returned beginning at the offset
    function fundraisers(uint256 limit, uint256 offset) 
        public 
        view 
        returns(Fundraiser[] memory collection) 
    {
        // Check first that the offset is not greater than the number of
        // Fundraiser contracts in the collection
        require(offset <= fundraisersCount(), "offset out of bounds");

        // Determine the correct size of the collection to be returned.
        // Size is initialised as the number of Fundraiser contracts in
        // _fundraisers collection less the offset value passed in.
        // Depending upon the value passes in for limit, the size of the
        // collection to be returned will either be:
        //  1. size;
        //  2. limit; or
        //  3. maxLimit
        uint256 size = fundraisersCount() - offset;
        size = size < limit ? size : limit;
        size = size < maxLimit ? size : maxLimit;
        collection = new Fundraiser[](size);

        // Iterate through the _fundraisers collection building up
        // a new collection of Fundraiser contracts starting from
        // the offset
        for (uint256 i = 0; i < size; i++) {
            collection[i] = _fundraisers[offset + i];
        }

        return collection;
    }
}