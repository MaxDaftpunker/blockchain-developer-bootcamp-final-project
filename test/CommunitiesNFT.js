const CommunitiesNFT = artifacts.require("CommunitiesNFT");



contract("CommunitiesNFT", async accounts => {
    describe("Initial deployment", async () => {
      it("should assert true", async function () {
        await CommunitiesNFT.deployed();
        assert.isTrue(true);
      });

      it("Was deployed and it's intial MaxSupply value is 1000", async () => {
        // get subject
        const ssInstance = await CommunitiesNFT.deployed();
        // verify maxSupply
        const maxSupply = await ssInstance.maxSupply.call();
        assert.equal(maxSupply, 1000, `Initial supply should be 1000`);
      });


  
      
    });
    describe("Functionality", async () => {
      it("Something", async () => {
        //get subject
        const ssInstance = await CommunitiesNFT.deployed();

        //setCost
        await ssInstance.setCost(1);

        const newCost = await ssInstance.setCost.call(1);
        assert.equal(newCost, 1, `${newCost} was not stored!`);  





      });



    });    
      


  });