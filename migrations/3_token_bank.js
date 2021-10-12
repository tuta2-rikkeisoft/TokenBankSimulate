const TokenBank = artifacts.require("./tokenbank.sol");

module.exports = function (deployer) {
  deployer.deploy(TokenBank);
};
