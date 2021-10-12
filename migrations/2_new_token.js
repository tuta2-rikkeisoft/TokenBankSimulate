const NewToken = artifacts.require("./newtoken.sol");

module.exports = function (deployer) {
  deployer.deploy(NewToken);
};
