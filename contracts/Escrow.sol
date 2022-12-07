//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

interface IERC721 {
    function transferFrom(
        address _from,
        address _to,
        uint256 _id
    ) external;
}

contract Escrow {

    //---ADDRESSES-------
    address public nftAddress;
    address payable public seller;
    address public inspector;
    address public lender;

    //--------MODIFIERS---------
    modifier onlyBuyer(uint256 _nftID){
        require(msg.sender == buyer[_nftID], "only buyer can call this method");
        _;
    }

    modifier onlySeller() {
        require(msg.sender == seller, "Only seller can call this method");
        _;
    }

    //------MAPPINGS---------------
    mapping(uint256 => bool)public isListed;
    mapping(uint256 => uint256)public purchasePrice;
    mapping(uint256 => uint256)public escrowAmount;
    mapping(uint256 => address)public buyer;

    constructor(
        address _nftAddress, 
        address payable _seller, 
        address _inspector, 
        address _lender
    ){
        nftAddress = _nftAddress;
        seller = _seller;
        inspector = _inspector;
        lender = _lender;

    } 
     /**
     * @dev this function transfers the nft the seller minted in the real estate contract and sends
     * sends it to this contract 
     * @dev this function is gotten from erc721 with the interface above
     * @param _nftID is the id of the nft we want to collect which is the same one he minted in the 
     * real estate contract
     */
    function list(
        uint256 _nftID, 
        address _buyer, 
        uint256 _purchasePrice, 
        uint256 _escrowAmount
    ) public payable onlySeller {
        // Transfer NFT from seller to this contract
        IERC721(nftAddress).transferFrom(msg.sender, address(this), _nftID);

        isListed[_nftID] = true;
        purchasePrice[_nftID] = _purchasePrice;
        escrowAmount[_nftID] = _escrowAmount;
        buyer[_nftID] = _buyer;
    }

     //Put under contract (only buyer - payable escrow)
     function depositEarnest(uint256 _nftID) public payable onlyBuyer(_nftID){
        require(msg.value >= escrowAmount[_nftID]);
     }

     


}
