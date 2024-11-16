const { ethers } = require("hardhat");

async function main() {
  console.log("Deploying Verifier...");

  const Verifier = await ethers.getContractFactory("Groth16Verifier");
  const verifier = await Verifier.deploy();
  await verifier.deployed();

  console.log("Verifier deployed to:", verifier.address);
}

main().catch((error) => {
  console.error("Error deploying Verifier:", error);
  process.exitCode = 1;
});