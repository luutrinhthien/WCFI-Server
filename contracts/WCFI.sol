// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract WCFI is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    using Strings for uint256;
    Counters.Counter private _tokenIds;

    // mapping(uint256 => address) private _tokenOwners;
    uint256[] private _tokenIdsList;

    uint256 public mintFee;

    constructor(uint256 InitialMintFee) ERC721("Shoes", "WCFI") {
        mintFee = (InitialMintFee * 1 wei);
    }

    function setMintFee(uint256 _mintFee) public onlyOwner {
        mintFee = _mintFee;
    }

    event ListNFT(address indexed _from, uint256 _tokenId, uint256 _price);
    event UnlistNFT(address indexed _from, uint256 _tokenId);
    event BuyNFT(address indexed _from, uint256 _tokenId, uint256 _price);
    event UpdateListingNFTPrice(uint256 _tokenId, uint256 _price);
    // event SetTax(uint256 _tax);

    event minted(string country, uint256 tokenId);

    // update country
    // https://ipfs.io/ipfs/Qmd5rHRVP2pngQnn5ednAyfkZwYjZ9pVwjPVf6SurvyGAv/Tier1/Argentina.png
    // https://ipfs.io/ipfs/QmUYvpAWvxBCNh1SWHqm4NTzSZuKXAixi5gsndeHLsiap2/Tier1/argentina.json

    function mint() public payable returns (uint256) {
        require(msg.value >= (mintFee * 1 wei), "Insufficient mint fee");

        string
            memory domain = "https://ipfs.io/ipfs/QmUYvpAWvxBCNh1SWHqm4NTzSZuKXAixi5gsndeHLsiap2/";
        string memory tokenURI;

        string memory rtEvent;

        uint256 randomNumber = getRandomNumber(10000);

        // If the user mint less than 2 times
        if (balanceOf(msg.sender) < 3) {
            if (randomNumber <= 7) {
                tokenURI = string(
                    abi.encodePacked(domain, "Tier1/brazil.json")
                );
                rtEvent = "brazil";
            } else if (randomNumber <= 17) {
                tokenURI = string(
                    abi.encodePacked(domain, "Tier1/france.json")
                );
                rtEvent = "france";
            } else if (randomNumber <= 28) {
                tokenURI = string(
                    abi.encodePacked(domain, "Tier1/england.json")
                );
                rtEvent = "england";
            } else if (randomNumber <= 42) {
                tokenURI = string(abi.encodePacked(domain, "Tier1/spain.json"));
                rtEvent = "spain";
            } else if (randomNumber <= 61) {
                tokenURI = string(
                    abi.encodePacked(domain, "Tier1/germany.json")
                );
                rtEvent = "germany";
            } else if (randomNumber <= 80) {
                tokenURI = string(
                    abi.encodePacked(domain, "Tier1/argentina.json")
                );
                rtEvent = "argentina";
            } else if (randomNumber <= 102) {
                tokenURI = string(
                    abi.encodePacked(domain, "Tier1/belgium.json")
                );
                rtEvent = "belgium";
            } else if (randomNumber <= 124) {
                tokenURI = string(
                    abi.encodePacked(domain, "Tier1/portugal.json")
                );
                rtEvent = "portugal";
            } else if (randomNumber <= 150) {
                tokenURI = string(
                    abi.encodePacked(domain, "Tier2/netherlands.json")
                );
                rtEvent = "netherlands";
            } else if (randomNumber <= 202) {
                tokenURI = string(
                    abi.encodePacked(domain, "Tier2/denmark.json")
                );
                rtEvent = "denmark";
            } else if (randomNumber <= 267) {
                tokenURI = string(
                    abi.encodePacked(domain, "Tier2/croatia.json")
                );
                rtEvent = "croatia";
            } else if (randomNumber <= 360) {
                tokenURI = string(
                    abi.encodePacked(domain, "Tier2/uruguay.json")
                );
                rtEvent = "uruguay";
            } else if (randomNumber <= 481) {
                tokenURI = string(
                    abi.encodePacked(domain, "Tier2/poland.json")
                );
                rtEvent = "poland";
            } else if (randomNumber <= 602) {
                tokenURI = string(
                    abi.encodePacked(domain, "Tier2/senegal.json")
                );
                rtEvent = "senegal";
            } else if (randomNumber <= 751) {
                tokenURI = string(abi.encodePacked(domain, "Tier2/usa.json"));
                rtEvent = "usa";
            } else if (randomNumber <= 900) {
                tokenURI = string(
                    abi.encodePacked(domain, "Tier2/serbia.json")
                );
                rtEvent = "serbia";
            } else if (randomNumber <= 1049) {
                tokenURI = string(
                    abi.encodePacked(domain, "Tier3/switzerland.json")
                );
                rtEvent = "switzerland";
            } else if (randomNumber <= 1235) {
                tokenURI = string(
                    abi.encodePacked(domain, "Tier3/mexico.json")
                );
                rtEvent = "mexico";
            } else if (randomNumber <= 1421) {
                tokenURI = string(abi.encodePacked(domain, "Tier3/wales.json"));
                rtEvent = "wales";
            } else if (randomNumber <= 1701) {
                tokenURI = string(abi.encodePacked(domain, "Tier3/ghana.json"));
                rtEvent = "ghana";
            } else if (randomNumber <= 1981) {
                tokenURI = string(
                    abi.encodePacked(domain, "Tier3/ecuador.json")
                );
                rtEvent = "ecuador";
            } else if (randomNumber <= 2354) {
                tokenURI = string(
                    abi.encodePacked(domain, "Tier3/morocco.json")
                );
                rtEvent = "morocco";
            } else if (randomNumber <= 2820) {
                tokenURI = string(
                    abi.encodePacked(domain, "Tier3/cameroon.json")
                );
                rtEvent = "cameroon";
            } else if (randomNumber <= 3286) {
                tokenURI = string(
                    abi.encodePacked(domain, "Tier3/canada.json")
                );
                rtEvent = "canada";
            } else if (randomNumber <= 3752) {
                tokenURI = string(abi.encodePacked(domain, "Tier4/japan.json"));
                rtEvent = "japan";
            } else if (randomNumber <= 4218) {
                tokenURI = string(abi.encodePacked(domain, "Tier4/qatar.json"));
                rtEvent = "qatar";
            } else if (randomNumber <= 4777) {
                tokenURI = string(
                    abi.encodePacked(domain, "Tier4/tunisia.json")
                );
                rtEvent = "tunisia";
            } else if (randomNumber <= 5523) {
                tokenURI = string(abi.encodePacked(domain, "Tier4/korea.json"));
                rtEvent = "korea";
            } else if (randomNumber <= 6269) {
                tokenURI = string(
                    abi.encodePacked(domain, "Tier4/australia.json")
                );
                rtEvent = "australia";
            } else if (randomNumber <= 7201) {
                tokenURI = string(abi.encodePacked(domain, "Tier4/iran.json"));
                rtEvent = "iran";
            } else if (randomNumber <= 8133) {
                tokenURI = string(
                    abi.encodePacked(domain, "Tier4/saudiArabia.json")
                );
                rtEvent = "saudiArabia";
            } else {
                tokenURI = string(
                    abi.encodePacked(domain, "Tier4/costaRica.json")
                );
                rtEvent = "costaRica";
            }
        }
        // If the user mint more than 2 times
        else {
            uint256 randomNumber2 = getRandomNumber(16);
            if (randomNumber2 == 0) {
                tokenURI = string(
                    abi.encodePacked(domain, "Tier1/brazil.json")
                );
                rtEvent = "brazil";
            } else if (randomNumber2 == 1) {
                tokenURI = string(
                    abi.encodePacked(domain, "Tier1/france.json")
                );
                rtEvent = "france";
            } else if (randomNumber2 == 2) {
                tokenURI = string(
                    abi.encodePacked(domain, "Tier1/england.json")
                );
                rtEvent = "england";
            } else if (randomNumber2 == 3) {
                tokenURI = string(abi.encodePacked(domain, "Tier1/spain.json"));
                rtEvent = "spain";
            } else if (randomNumber2 == 4) {
                tokenURI = string(
                    abi.encodePacked(domain, "Tier1/germany.json")
                );
                rtEvent = "germany";
            } else if (randomNumber2 == 5) {
                tokenURI = string(
                    abi.encodePacked(domain, "Tier1/argentina.json")
                );
                rtEvent = "argentina";
            } else if (randomNumber2 == 6) {
                tokenURI = string(
                    abi.encodePacked(domain, "Tier1/belgium.json")
                );
                rtEvent = "belgium";
            } else if (randomNumber2 == 7) {
                tokenURI = string(
                    abi.encodePacked(domain, "Tier1/portugal.json")
                );
                rtEvent = "portugal";
            } else if (randomNumber2 == 8) {
                tokenURI = string(
                    abi.encodePacked(domain, "Tier2/netherlands.json")
                );
                rtEvent = "netherlands";
            } else if (randomNumber2 == 9) {
                tokenURI = string(
                    abi.encodePacked(domain, "Tier2/denmark.json")
                );
                rtEvent = "denmark";
            } else if (randomNumber2 == 10) {
                tokenURI = string(
                    abi.encodePacked(domain, "Tier2/croatia.json")
                );
                rtEvent = "croatia";
            } else if (randomNumber2 == 11) {
                tokenURI = string(
                    abi.encodePacked(domain, "Tier2/uruguay.json")
                );
                rtEvent = "uruguay";
            } else if (randomNumber2 == 12) {
                tokenURI = string(
                    abi.encodePacked(domain, "Tier2/poland.json")
                );
                rtEvent = "poland";
            } else if (randomNumber2 == 13) {
                tokenURI = string(
                    abi.encodePacked(domain, "Tier2/senegal.json")
                );
                rtEvent = "senegal";
            } else if (randomNumber2 == 14) {
                tokenURI = string(abi.encodePacked(domain, "Tier2/usa.json"));
                rtEvent = "usa";
            } else {
                tokenURI = string(
                    abi.encodePacked(domain, "Tier2/serbia.json")
                );
                rtEvent = "serbia";
            }
        }

        uint256 newItemId = _tokenIds.current();
        _mint(msg.sender, newItemId);
        _setTokenURI(newItemId, tokenURI);

        _tokenIds.increment();
        // _tokenOwners[newItemId] = msg.sender;
        _tokenIdsList.push(newItemId);

        emit minted(rtEvent, newItemId);

        return newItemId;
    }

    function tokenOfOwnerByIndex(
        address owner,
        uint256 index
    ) public view virtual returns (uint256) {
        require(
            owner != address(0),
            "ERC721: owner query for nonexistent token"
        );

        uint256 tokenCount = balanceOf(owner);
        require(
            index < tokenCount,
            "ERC721Enumerable: owner index out of bounds"
        );

        uint256 currentIndex = 0;

        for (uint256 i = 0; i < _tokenIdsList.length; i++) {
            uint256 tokenId = _tokenIdsList[i];
            if (ownerOf(tokenId) == owner) {
                if (currentIndex == index) {
                    return tokenId;
                }
                currentIndex++;
            }
        }

        revert("ERC721Enumerable: owner index not found");
    }

    function listTokenIds(
        address owner
    ) external view returns (uint256[] memory tokenIds) {
        uint balance = balanceOf(owner);
        uint256[] memory ids = new uint256[](balance);

        for (uint i = 0; i < balance; i++) {
            ids[i] = tokenOfOwnerByIndex(owner, i);
        }
        return (ids);
    }

    function withdraw() public onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }

    function getNumberMinted() public view returns (uint256) {
        return _tokenIds.current();
    }

    function getRandomNumber(uint256 range) public view returns (uint256) {
        uint256 randomNumber = uint256(
            keccak256(abi.encodePacked(block.timestamp, block.difficulty))
        ) % range;
        return randomNumber;
    }

    // SPDX-IGNORE
    function emitListNFT(
        address from,
        uint256 tokenId,
        uint256 price
    ) external {
        emit ListNFT(from, tokenId, price);
    }

    // SPDX-IGNORE
    function emitBuyNFT(address from, uint256 tokenId, uint256 price) external {
        emit BuyNFT(from, tokenId, price);
    }

    // SPDX-IGNORE
    function emitUnlistNFT(address from, uint256 tokenId) external {
        emit UnlistNFT(from, tokenId);
    }

    // SPDX-IGNORE
    function emitUpdateListingNFTPrice(
        uint256 _tokenId,
        uint256 _price
    ) external {
        emit UpdateListingNFTPrice(_tokenId, _price);
    }
}
