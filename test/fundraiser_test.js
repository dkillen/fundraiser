const FundRaiserContract = artifacts.require("Fundraiser");

contract("Fundraiser", accounts => {
    let fundraiser;
    const name = "Beneficiary Name"

    describe("Initialization", () => {
        beforeEach (async () => {
            fundraiser = await FundRaiserContract.new(name);
        });
        it("gets the beneficiary name", async () => {
            const actual = await fundraiser.name();
            assert.equal(actual, name, "names should match");
        });
    });
});