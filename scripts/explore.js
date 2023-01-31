// Import the contract artifacts and contract instance
import { contractArtifact, instance } from "../../build/contracts/BountyPlatform.json";

// Import the Web3 library
import Web3 from "web3";

// Set the provider for the contract
const provider = new Web3.providers.HttpProvider("http://localhost:8545");
const contract = require("@truffle/contract");

// Create an instance of the contract
const bountyPlatform = contract(contractArtifact);
bountyPlatform.setProvider(provider);

// Get the list of bounties from the contract
async function getBounties() {
  const bountyIds = await instance.getBountyIds();
  const bounties = [];

  // Retrieve the details of each bounty
  for (const id of bountyIds) {
    const bounty = await instance.getBounty(id);
    bounties.push(bounty);
  }

  return bounties;
}

// Display the list of bounties on the page
async function displayBounties() {
  const bounties = await getBounties();
  const bountiesDiv = document.getElementById("bounties");

  // Create a div for each bounty
  for (const bounty of bounties) {
    const div = document.createElement("div");
    div.classList.add("bounty");

    // Display the name and description of the bounty
    const name = document.createElement("h3");
    name.textContent = bounty[0];
    div.appendChild(name);
    const description = document.createElement("p");
    description.textContent = bounty[1];
    div.appendChild(description);

    // Display the funded amount and goal
    const funded = document.createElement("p");
    funded.textContent = `Funded: ${bounty[3]} / ${bounty[2]}`;
    div.appendChild(funded);

    // Add the div to the list of bounties
    bountiesDiv.appendChild(div);
  }
}

// Call the displayBounties function when the page loads
displayBounties();
