const hre = require("hardhat");

async function main() {
  // We get the contract to deploy
  const NFTStaking = await hre.ethers.getContractFactory("NFTStaking");
  const nftStaking = await NFTStaking.deploy(
    "JewNFT",
    "JNT",
    "0xeF4941E2AF682F92e27542cB89c909d04cBA8977"
  );

  await nftStaking.deployed();

  console.log("NFTstaking deployed to:", nftStaking.address);

  await hre.run("verify:verify", {
    address: nftStaking.address,
    contract: "contracts/NFTStaking.sol:NFTStaking",
    constructorArguments: [
      "JewNFT",
      "JNT",
      "0xeF4941E2AF682F92e27542cB89c909d04cBA8977",
    ],
  });
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
