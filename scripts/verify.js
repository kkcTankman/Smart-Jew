const hre = require("hardhat");

async function main() {
  await hre.run("verify:verify", {
    address: "0x1326b7241d49bd4f75dfbcf94c22776856b20679",
    contract: "contracts/NFTStaking.sol:NFTStaking",
    constructorArguments: [
      "JewNFT",
      "JNT",
      "0xeF4941E2AF682F92e27542cB89c909d04cBA8977",
    ],
  });

  console.log("success");

  // await hre.run("verify:verify", {
  //     address : "0x5BA370347E1f5F21Ec3Cebbd9Ac567a7211CAC79",
  //     contract : "contracts/MockNFT.sol:MockNFT",
  //     constructorArguments : []
  // });
  //     console.log("success");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
