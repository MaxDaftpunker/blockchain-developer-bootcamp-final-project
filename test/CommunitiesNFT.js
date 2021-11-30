const CommunitiesNFT = artifacts.require("CommunitiesNFT");
const toBN = web3.utils.toBN;

const getErrorObj = (obj = {}) => {
  const txHash = Object.keys(obj)[0];
  return obj[txHash];
};


contract("CommunitiesNFT", (accounts) => {

  let contract;
  const fee = toBN("10000000000000000");

  before(async () => {
    contract = await CommunitiesNFT.deployed();
  });


  describe("Initial deployment", async () => {
    it("contract should deployed correctly", async function () {
      const address = await contract.address;
      assert.notEqual(address, 0x0);
      assert.notEqual(address, "");
      assert.notEqual(address, null);
    });

    it("contract should not be paused upon deployment", async () => {
      const owner = await contract.owner;
      assert.isFalse(await contract.paused(), "The contract is paused");
    });

    it("contract should be deployed with the correct name and symbol", async () => {
      assert.equal(await contract.name(), "CommunitiesNFT", "The contract was not deployed with the expected name");
      assert.equal(await contract.symbol(), "CCN", "The contract was not deployed with the expected symbol");
    });

    it("contract intial maxSupply should be 10000", async () => {
      const maxSupply = await contract.maxSupply.call();
      assert.equal(maxSupply, 10000, `Initial supply is not 10000`);
    });      
  });


  describe("Minting", async () => {
    it("should whitelist an account for minting", async () => {      
      const minter = accounts[1];
      const isWhite = await contract.whitelistUser(minter);
      assert.isTrue(isWhite.receipt.status, "Not OK");
    });

    it("should confirm that the account is whitelisted", async () => {   
      const minter = accounts[1];  
      assert.isTrue(await contract.whitelisted(minter), "the account was not added to the whitelist");
    });

    it("should be able to mint with a whitelisted account", async () => {      
      const minter = accounts[1];      
      await contract.mint({ from: minter, value: fee});
      const tokenId = await contract.tokensMinted();
      assert.isTrue(tokenId > 1, "the account was not able to mint");
    });

    it("should be able to remove a whitelisted account", async () => {      
      const minter = accounts[1];
      const isNotWhite = await contract.removeWhitelistUser(minter);
      assert.isTrue(isNotWhite.receipt.status, "Not ");
    });

    it("should confirm a that user were remove from the whitelist", async () => {   
      const minter = accounts[1];   
      assert.isFalse(await contract.whitelisted(minter), "Not OK");
    });

    it("shouldn't an account not on the whitelist be able to mint", async () => {    
      try {  
        const minter = accounts[2];      
        await contract.mint({ from: minter, value: fee});
      }  
      catch (e) { 
        const { error, reason } = getErrorObj(e.data);
        assert.equal(error, "revert");
      }  
    });

  });
});