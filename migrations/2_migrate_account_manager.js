const AccountManager = artifacts.require("./AccountManager.sol");

module.exports = function(deployer) {
    deployer.deploy(AccountManager);
};
