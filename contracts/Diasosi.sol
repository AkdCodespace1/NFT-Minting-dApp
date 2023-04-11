// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

//Contracts imported from OpenZeppelin because the contract has been audited for security and efficiency, in order not to reinvent the wheel
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract DiasosiNFT is ERC721URIStorage, Ownable {
using Counters for Counters.Counter;
Counters.Counter private _tokenIds;
Counters.Counter private _totalMinted;

mapping(address => uint8) private _mintedAddress;
mapping(string => uint8) private _uriMapping;
uint256 public _pricePerToken = 0.01 ether;
uint256 public _limitPerAddress = 2;
uint256 public _maxSupply  = 5;

constructor() ERC721("DiasosiNFT", "NFTM") {}

// Function to set the price of a token
function setPrice(uint256 price) external onlyOwner{
    _pricePerToken = price;
}

// Function to set the maximum number of tokens that can be minted per address
function setLimit(uint256 limit) external onlyOwner{
    _limitPerAddress = limit;
}

// Function to set the maximum number of tokens that can be minted in the marketplace
function setMaxSupply(uint256 maxSupply) external onlyOwner{
    _maxSupply = maxSupply;
}

// Function to mint a new token
function mintNFT(string memory tokenURI) payable external returns (uint256){
    require(_pricePerToken <= msg.value, "Ether paid is not enough");
    require(_mintedAddress[msg.sender] < _limitPerAddress, "You have exceeded the limit you can mint");
    require(_totalMinted.current() + 1 <= _maxSupply, "You have exceeded the maximum supply of tokens");
    require(_uriMapping[tokenURI] == 0, "This NFT has already been minted");

    _uriMapping[tokenURI] += 1;
    _mintedAddress[msg.sender] += 1;
    _tokenIds.increment();
    _totalMinted.increment();

    uint256 newItemId = _tokenIds.current();
    _mint(msg.sender, newItemId);
    _setTokenURI(newItemId, tokenURI);

    return newItemId;
}

// Function to withdraw funds from the contract
function withdrawFunds() external onlyOwner{
    address payable to = payable(msg.sender);
    to.transfer(address(this).balance);
}
}