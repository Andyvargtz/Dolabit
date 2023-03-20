const { ethers } = require("hardhat");
require("dotenv").config();

const VENDOR_ID = process.env.VENDOR_ID;

async function freeAssets() {
  const escrow = await ethers.getContract("Escrow");
  const vendorId = 03; //Esto se consulta de Polybase
  await escrow.freeAssets({ value: VENDOR_ID });
  console.log("Payment Completed!");
}

freeAssets()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
