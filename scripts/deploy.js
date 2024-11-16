const { ethers } = require("hardhat");

async function main() {

  const verifierAddress = "0x201B30C1B71E3Dcf61bE22D04166A854203c6E90";

  console.log("Deploying CuriosChallenge...");

  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address);


  const CuriosChallenge = await ethers.getContractFactory("CuriosChallenge");
  const curiosChallenge = await CuriosChallenge.deploy(verifierAddress, deployer.address);
  
  await curiosChallenge.waitForDeployment();

  console.log("CuriosChallenge deployed to:", curiosChallenge.address);
}

main().catch((error) => {
  console.error("Error deploying contracts:", error);
  process.exitCode = 1;
});
