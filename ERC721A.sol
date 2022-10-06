// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "erc721a/contracts/ERC721A.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ERC is ERC721A, Ownable {
    uint256 MAX_MINTS = 50;
    uint256 MAX_SUPPLY = 10000;
    uint256 public mintRate = 0.0069 ether;

    string public baseURI = "ipfs://bafybeieyetlp2c2vubffzjjap7utuz5jwo2k5b5kupvezfchc5tnfg4fh4/";

    constructor() ERC721A("ERC", "ERC") {}

    function mint(uint256 quantity) external payable {
        // _safeMint's second argument now takes in a quantity, not a tokenId.
        require(quantity + _numberMinted(msg.sender) <= MAX_MINTS, "Exceeded the limit");
        require(totalSupply() + quantity <= MAX_SUPPLY, "Not enough tokens left");
        require(msg.value >= (mintRate * quantity), "Not enough ether sent");
        _safeMint(msg.sender, quantity);
    }

    function crossmint(address _to) external payable {
        require(totalSupply() + 1 <= MAX_SUPPLY, "Not enough tokens left");
        require(msg.value >= mintRate, "Not enough ether sent");
        _safeMint(_to, totalSupply() + 1);
    }

    function withdraw() external payable onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }

    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }

    function setMintRate(uint256 _mintRate) public onlyOwner {
        mintRate = _mintRate;
    }
}
