const { ethers }  = require('hardhat');

async function main() {
    const TEST = await ethers.getContractFactory('MyContract');
    const test = await TEST.deploy();
  
    await test.deployed();
  
    console.log('Test deployed to:', test.address);
  
    // /*
    // Deploy step airdrop
    // 1. Deploy with token address
    // 2. Transfer token to airdrop address
    // 3. excecute Token excludeFee(airdrop address)
    // 4. run npx hardhat run scripts/airdrop.js --network mainnet
    // */
    // const DoubleMoon = await ethers.getContractFactory('DoubleMoonAirdrop');
    // // const doubleMoon = await DoubleMoon.deploy('0xc9E79de0D090d51eE64bd3833359B90F8a0ef423'); // testnet
    // const doubleMoon = await DoubleMoon.deploy('0x0314e5a39806C30D67B869EE1bCDABee7e08dE74'); // mainnet
  
    // await doubleMoon.deployed();
  
    // console.log('DoubleMoonAirdrop deployed to:', doubleMoon.address);
  }
  
  main()
    .then(() => process.exit(0))
    .catch(error => {
      console.error(error);
      process.exit(1);
    });