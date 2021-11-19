const CommunitiesNFT = artifacts.require("CommunitiesNFT");
const Base64 = artifacts.require("../contracts/libraries/Base64.sol");

module.exports = function (deployer) {
  deployer.deploy(CommunitiesNFT, "CommunitiesNFT", "CCN");
  deployer.deploy(Base64);
};