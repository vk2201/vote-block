const hre = require("hardhat");

async function main() {
  const Election = await hre.ethers.getContractFactory("Election");
  const [owner, addr1, ...addrs] = await ethers.getSigners(); 
  const election = await Election.deploy(owner.address);
  

  await election.deployed();
  console.log("Election contract deployed to:", election.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
