// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {
  //setup accounts
  [buyer, seller, inspector, lender] = await ethers.getSigners()

  //deploy real estate
  const RealEstate = await ethers.getContractFactory('RealEstate')
  const realEstate = await RealEstate.deploy()
  await realEstate.deployed()

  console.log('Deployed Real Estate Contract at: ', realEstate.address)
  console.log("Minting properties.....\n")

//Minting

  for(let i=0; i<3; i++){
    const transaction = await realEstate.connect(seller).mint(`https://ipfs.io/ipfs/QmQVcpsjrA6cr1iJjZAodYwmPekYgbnXGo4DFubJiLc2EB/${i+1}.json`)
    await transaction.wait()
  }
}

//deploy escrow
const Escrow = await ethers.getContractFactory('Escrow')
const escrow = await Escrow.deploy(
  realEstate.address,
  seller.address,
  inspector.address,
  lender.address
)
await escrow.deployed()

for(let i=0; i<3; i++){
  //Approve properties
  let transaction = await realEstate.connect(seller).approve(escrow.address, i+1);
  await transaction.wait()
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
