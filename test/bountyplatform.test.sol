//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.9;

import "/Users/MacBookAirSF/bounty-platform/contracts/bountyplatform.sol";

contract TestBountyPlatform {
    BountyPlatform bountyPlatform = new BountyPlatform();

    function testIssueBounty() public {
        // Set up the test environment
        address issuer = msg.sender;
        uint256 amount = 100;
        // Call the issueBounty function of the contract
        bountyPlatform.issueBounty("Test bounty", "Description of test bounty", amount);

        // Assert that the bounty was issued successfully
        BountyPlatform.Bounty storage bounty = bountyPlatform.bounties(0);
        assert(bounty.issuer == issuer);
        assert(bounty.name == "Test bounty");
        assert(bounty.description == "Description of test bounty");
        assert(bounty.amount == amount);
        assert(bounty.fundedAmount == 0);
        assert(bounty.status == BountyPlatform.BountyStatus.Open);
    }

        function testFundBounty() public {
        // Set up the test environment
        address funder = msg.sender;
        uint256 amount = 50;
        // Call the fundBounty function of the contract
        bountyPlatform.fundBounty(0, funder, amount);

        // Assert that the bounty was funded successfully
        BountyPlatform.Bounty storage bounty = bountyPlatform.bounties(0);
        assert(bounty.fundedAmount == amount);
        assert(bounty.status == BountyPlatform.BountyStatus.Funded);
        assert(bountyPlatform.funders(0, 0) == funder);
    }

    function testCompleteBounty() public {
        // Set up the test environment
        address issuer = msg.sender;

        // Call the completeBounty function of the contract
        bountyPlatform.completeBounty(0);

        // Assert that the bounty was completed successfully
        BountyPlatform.Bounty storage bounty = bountyPlatform.bounties(0);
        assert(bounty.status == BountyPlatform.BountyStatus.Completed);
    }
}

