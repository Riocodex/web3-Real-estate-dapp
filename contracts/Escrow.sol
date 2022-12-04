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
    address public nftAddress;
    address payable public seller;
    address public inspector;
    address public lender;

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
     * @dev this function is gotten from erc20
     * @param _nftID is the id of the nft we want to collect which is the same one he minted in the 
     * real estate contract
     */
    function list(uint256 _nftID) public {
        IERC20(nftAddress).transferFrom(msg.sender, address(this), _nftID);
    }
}
