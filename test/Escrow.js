const { expect } = require('chai');
const { ethers } = require('hardhat');

const tokens = (n) => {
    return ethers.utils.parseUnits(n.toString(), 'ether')
}

describe('Escrow', () => {
    let buyer, seller
    let realEstate, escrow

    beforeEach( async () =>{
        [buyer, seller, inspector, lender] = await ethers.getSigners()
       
        //deploy Real Estate
        const RealEstate = await ethers.getContractFactory('RealEstate');
        realEstate = await RealEstate.deploy()
        
        //Mint
        let transaction = await realEstate.connect(seller).mint("https://ipfs.io/ipfs/QmTudSYeM7mz3PkYEWXWqPjomRPHogcMFSq7XAvsvsgAPS")
        await transaction.wait()

        const Escrow = await ethers.getContractFactory("Escrow")
        escrow = await Escrow.deploy(
            realEstate.address,
            seller.address,
            inspector.address,
            lender.address
        )
    })

    describe('Deployment' () =>{
        it('Returns NFT address', async () =>{

        })
        it('Returns seller', async () =>{
            
        })
        it('Returns inspector', async () =>{
            
        })
        it('Returns lender', async () =>{
            
        })
    })


    it('saves the addresses', async() =>{
        
        [buyer, seller, inspector, lender] = await ethers.getSigners()
       
        //deploy Real Estate
        const RealEstate = await ethers.getContractFactory('RealEstate');
        realEstate = await RealEstate.deploy()
        
        //Mint
        let transaction = await realEstate.connect(seller).mint("https://ipfs.io/ipfs/QmTudSYeM7mz3PkYEWXWqPjomRPHogcMFSq7XAvsvsgAPS")
        await transaction.wait()

        const Escrow = await ethers.getContractFactory("Escrow")
        escrow = await Escrow.deploy(
            realEstate.address,
            seller.address,
            inspector.address,
            lender.address
        )
            //checking the addresses

        let result = await escrow.nftAddress()
        expect(result).to.be.equal(realEstate.address)

        result = await escrow.seller()
        expect(result).to.be.equal(seller.address)
        
    })
})
// 
