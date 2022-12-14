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

    modifier onlyInspector() {
        require(msg.sender == inspector, "only inspector can call this method");
            _;
        
    }

    //------MAPPINGS---------------
    mapping(uint256 => bool)public isListed;
    mapping(uint256 => uint256)public purchasePrice;
    mapping(uint256 => uint256)public escrowAmount;
    mapping(uint256 => address)public buyer;
    mapping(uint256 => bool) public inspectionPassed;
    mapping(uint256 => mapping(address => bool)) public approval;

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

    //Update Inspection Status (only inspector)
    function updateInspectionStatus(uint256 _nftID, bool _passed)
    public
    {
        inspectionPassed[_nftID] = _passed;
    }

     //Put under contract (only buyer - payable escrow)
     function depositEarnest(uint256 _nftID) public payable onlyBuyer(_nftID){
        require(msg.value >= escrowAmount[_nftID]);
     }

     //Approve sale
     function approveSale(uint256 _nftID)public{
        approval[_nftID][msg.sender] = true; 
     }

     
     /**
      * Finalize Sale..We want this function to:
      * Require inspection status(add more items here, like appraisal)
      * Require sale to be authorized
      * Require funds to be correct amount
      * Transfer NFTS to buyer
      * Transfer funds to seller
      */
     function finalizeSale(uint256 _nftID)public{
        //checking requirements
        require(inspectionPassed[_nftID]);
        require(approval[_nftID][buyer[_nftID]]);
        require(approval[_nftID][seller]);
        require(approval[_nftID][lender]);
        require(address(this).balance >= purchasePrice[_nftID]);

        //making sure the nft is no longer listed
        isListed[_nftID] = false;

        //sending money to the seller
        (bool success, ) = payable(seller).call{value: address(this).balance}("");
        require(success);

        //transfering nft to buyer
        IERC721(nftAddress).transferFrom(address(this), buyer[_nftID], _nftID);

     }

     /**
      * Cancel sale(handle earnest deposit)
      * if the sale cancels this function willl:
      * refund to buyer
      * otherwise send to seller
      */
     function cancelSale(uint256 _nftID) public{
        if(inspectionPassed[_nftID] == false){
            payable(buyer[_nftID]).transfer(address(this).balance);
        }else{
            payable(seller).transfer(address(this).balance);
        }
     }

     receive() external payable {}
      
     function getBalance() public view returns(uint256){
        return address(this).balance;
     }

}
