//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./WCFI.sol";

contract WCFIMarketplace is IERC721Receiver, Ownable {
    using SafeMath for uint256;

    WCFI private _nft;
    uint256 private _tax = 5; // percentage
    mapping(uint256 => ListDetail) private _listDetail;

    struct ListDetail {
        address payable author;
        uint256 price;
        uint256 tokenId;
    }

    event ListNFT(address indexed _from, uint256 _tokenId, uint256 _price);
    event UnlistNFT(address indexed _from, uint256 _tokenId);
    event BuyNFT(address indexed _from, uint256 _tokenId, uint256 _price);
    event UpdateListingNFTPrice(uint256 _tokenId, uint256 _price);
    event SetTax(uint256 _tax);

    // event SetNFT(IERC721Enumerable _nft);

    constructor(address nft) {
        _nft = WCFI(nft);
    }

    function onERC721Received(
        address,
        address,
        uint256,
        bytes memory
    ) external pure override returns (bytes4) {
        return
            bytes4(
                keccak256("onERC721Received(address,address,uint256,bytes)")
            );
    }

    function setTax(uint256 tax) public onlyOwner {
        _tax = tax;
        emit SetTax(tax);
    }

    // function setNft(IERC721Enumerable nft) public onlyOwner {
    //     _nft = nft;
    //     emit SetNFT(nft);
    // }

    function getListedNft() public view returns (ListDetail[] memory) {
        uint256 balance = _nft.balanceOf(address(this));
        ListDetail[] memory myNft = new ListDetail[](balance);

        for (uint256 i = 0; i < balance; i++) {
            myNft[i] = _listDetail[_nft.tokenOfOwnerByIndex(address(this), i)];
        }
        return myNft;
    }

    function viewOwnerOf(uint256 tokenId) public view returns (address) {
        return _nft.ownerOf(tokenId);
    }

    function listNft(uint256 tokenId, uint256 price) public payable {
        require(
            _nft.ownerOf(tokenId) == msg.sender,
            "You are not the owner of this NFT"
        );
        // require(
        //     _nft.getApproved(tokenId) == address(this),
        //     "Marketplace is not approved to transfer this NFT"
        // );
        require(msg.value >= (price * 1 wei), "Insufficient payment");

        _listDetail[tokenId] = ListDetail(payable(msg.sender), price, tokenId);

        _nft.safeTransferFrom(msg.sender, address(this), tokenId);

        emit ListNFT(msg.sender, tokenId, price);
        _nft.emitListNFT(msg.sender, tokenId, price);
    }

    function updateListingNftPrice(uint256 tokenId, uint256 price) public {
        require(
            _nft.ownerOf(tokenId) == address(this),
            "This NFT doesn't exist on marketplace"
        );
        require(
            _listDetail[tokenId].author == msg.sender,
            "Only owner can update price of this NFT"
        );

        _listDetail[tokenId].price = price;
        emit UpdateListingNFTPrice(tokenId, price);
        _nft.emitUpdateListingNFTPrice(tokenId, price);
    }

    function unlistNft(uint256 tokenId) public {
        require(
            _nft.ownerOf(tokenId) == address(this),
            "This NFT doesn't exist on marketplace"
        );
        require(
            _listDetail[tokenId].author == msg.sender,
            "Only owner can unlist this NFT"
        );

        _nft.safeTransferFrom(address(this), msg.sender, tokenId);
        emit UnlistNFT(msg.sender, tokenId);
        _nft.emitUnlistNFT(msg.sender, tokenId);
    }

    function buyNft(uint256 tokenId) public payable {
        require(
            _nft.ownerOf(tokenId) == address(this),
            "This NFT doesn't exist on marketplace"
        );
        require(
            (_listDetail[tokenId].price * 1 wei) <= msg.value,
            "Minimum price has not been reached"
        );

        uint256 fee = (msg.value * _tax) / 100;
        _listDetail[tokenId].author.transfer(msg.value.sub(fee)); // transfer payment to the seller
        payable(owner()).transfer(fee); // transfer fee to the marketplace owner

        _nft.safeTransferFrom(address(this), msg.sender, tokenId); // transfer NFT ownership to the buyer
        emit BuyNFT(msg.sender, tokenId, msg.value);
        _nft.emitBuyNFT(msg.sender, tokenId, msg.value);
    }

    //

    function withdraw() public onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }
}
