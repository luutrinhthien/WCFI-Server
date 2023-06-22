const hre = require("hardhat");

async function main() {
  // const WCFI = await hre.ethers.getContractFactory("WCFI");
  // const wcfi = await WCFI.deploy(100000000000000);

  // await wcfi.deployed();
  // console.log("Successfully deployed NFT WCFI to: ", wcfi.address);

  // NFT main !important:         0x2F7f03CE934e7eA998F23C11925571C0e42C18bD

  // Marketplace main !important: 0x1f89A8596F1232D2Aacc9aF0aBa153489dEb30DE

  const NFTmarketplace = await hre.ethers.getContractFactory("WCFIMarketplace");
  const marketplace = await NFTmarketplace.deploy("0x2F7f03CE934e7eA998F23C11925571C0e42C18bD");

  await marketplace.deployed();
  console.log("Successfully deployed WCFIMarketplace to: ", marketplace.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
