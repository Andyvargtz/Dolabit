const { ethers } = require("hardhat");

const networkConfig = {
  default: {
    name: "hardhat",
    vendorId: 01,
  },
  31337: {
    name: "localhost",
    vendorId: 01,
  },
  11155111: {
    name: "sepolia",
    vendorId: 01,
  },
  1: {
    name: "mainnet",
    vendorId: 01,
  },
};

const developmentChains = ["hardhat", "localhost"];
const VERIFICATION_BLOCK_CONFIRMATIONS = 6;
const frontEndContractsFile =
  "../nextjs-smartcontract-lottery-fcc/constants/contractAddresses.json";
const frontEndAbiFile =
  "../nextjs-smartcontract-lottery-fcc/constants/abi.json";

module.exports = {
  networkConfig,
  developmentChains,
  VERIFICATION_BLOCK_CONFIRMATIONS,
  frontEndContractsFile,
  frontEndAbiFile,
};
