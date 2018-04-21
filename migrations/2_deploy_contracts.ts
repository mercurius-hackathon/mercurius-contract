const MercuriusCreator = artifacts.require("MercuriusCreator");
// const MintableNFT = artifacts.require("MintableNonFungibleToken");

module.exports = (deployer: any) => {
    deployer.deploy(MercuriusCreator);
};
