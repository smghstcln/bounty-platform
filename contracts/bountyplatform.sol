//SPDX-License-Identifier:UNLICENSED

pragma solidity ^0.8.9;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract BountyPlatform is Ownable {
  // Enum to represent the different states of a bounty
  enum BountyStatus { Open, Funded, Completed }

  // Struct to represent a bounty
  struct Bounty {
    address issuer;
    string name;
    string description;
    uint256 amount;
    uint256 fundedAmount;
    BountyStatus status;
  }

  // Mapping to store all the bounties
  mapping(uint256 => Bounty) public bounties;

  // Mapping to store the funders of each bounty
  mapping(uint256 => mapping(uint256 => address)) public funders;

  // Event to emit when a bounty is issued
  event BountyIssued(uint256 id, address issuer, string name, string description, uint256 amount);

  // Event to emit when a bounty is funded
  event BountyFunded(uint256 id, address funder, uint256 amount);

  // Event to emit when a bounty is completed
  event BountyCompleted(uint256 id, address issuer);

  // Function to issue a bounty
  function issueBounty(string memory name, string memory description, uint256 amount) public {
    // Check that the caller is the owner of the contract
    require(msg.sender == address(owner), "Only the owner can issue a bounty.");

    // Check that the amount is greater than 0
    require(amount > 0, "The amount must be greater than 0.");

    // Calculate the ID of the new bounty
    uint256 id = keys(bounties).length;

    // Create the new bounty
    Bounty memory bounty = Bounty(
      msg.sender,
      name,
      description,
      amount,
      0,
      BountyStatus.Open
    );

    // Store the bounty in the mapping
    bounties[id] = bounty;

    // Emit the BountyIssued event
    emit BountyIssued(id, msg.sender, name, description, amount);
  }

  // Function to fund a bounty
  function fundBounty(uint256 id, address payable funder, uint256 amount) public payable {
    require(bounties[id].issuer != funder, "The issuer cannot fund the bounty.");
    require(bounties[id].status == BountyStatus.Open, "The bounty is not open.");
    require(amount > 0, "The amount must be greater than 0.");
    require(funder.balance >= amount, "The funder does not have enough balance.");
    require(address(this).balance >= msg.gas, "The contract does not have enough balance to cover the transaction fee.");
    bounties[id].fundedAmount = bounties[id].fundedAmount.add(amount);
    if (bounties[id].fundedAmount == bounties[id].amount) {
      bounties[id].status = BountyStatus.Funded;
    }
    funder.transfer(amount);
    funders[id][funders[id].length] = funder;
    emit BountyFunded(id, funder, amount);
  }

  function completeBounty(uint256 id) public {
    require(msg.sender == owner(), "Only the owner can complete a bounty.");
    require(bounties[id].status == BountyStatus.Funded, "The bounty is not funded.");
    bounties[id].status = BountyStatus.Completed;
    emit BountyCompleted(id, bounties[id].issuer);
  }

  function getNumberOfFunders(uint256 id) public view returns (uint256) {
    return funders[id].length;
  }

  function getFunderCount(uint256 id) public view returns (uint256) {
    return funders[id].length;  
  }
  function getFunder(uint256 id, uint256 index) public view returns (address) {
    return funders[id][index];
  }

