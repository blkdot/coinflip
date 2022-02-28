require('dotenv').config();
const { expect } = require("chai");
const { expectRevert } = require('@openzeppelin/test-helpers');

describe("CoinFlip Events and State", function() {
  const GAMERESULT = ["WIN", "LOSE", "CANCELED"];
  let provider;
  let CoinFlip, owner, addr1, contract, contract1;
  let gameResultEvent;

  beforeEach(async () => {
    provider = ethers.getDefaultProvider();

    CoinFlip = await ethers.getContractFactory("CoinFlip");
    contract = await CoinFlip.deploy(`${process.env.REACT_APP_OWNER_ADDRESS}`, {value: ethers.utils.parseEther(`${process.env.REACT_APP_CONTRACT_BALANCE}`) });  
    await contract.deployed();
    
    [owner, addr1, _] = await ethers.getSigners();
    contract1 = contract.connect(addr1);

    // PROCESS GAME RESULT EVENT
    gameResultEvent = new Promise((resolve, reject) => {
      contract1.on('GameResult', (result, event) => {
        event.removeListener();
        console.log("Game result", GAMERESULT[result]);
        resolve({
          result,
        });
      });

      setTimeout(() => {
        reject(new Error('timeout'));
      }, 60000)
    });

  })

  // Seller

  it("Should check the betting event.", async function () {
    
    console.log("CoinFlip deployed to:", contract.address);
    // await owner.sendTransaction({
    //   to: contract.address,
    //   value: ethers.utils.parseEther("1.0"), // Sends exactly 1.0 ether
    // });
    console.log("Contract balance", ethers.utils.formatEther(await contract.getDealerBalance()));
    console.log("Before balance", ethers.utils.formatEther(await addr1.getBalance()));
    let updatedWager = ethers.utils.parseEther("0.001");
    const tx = await contract1.bet(true, {value: updatedWager });
    let event = await gameResultEvent;
    console.log("After balance", ethers.utils.formatEther(await addr1.getBalance()));


  });

});
