// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;


import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

// Import helper functions needed for Base64 encoding.
import { Base64 } from "./libraries/Base64.sol";

contract CommunitiesNFT is ERC721, Ownable {
  using Strings for uint256;
  using Counters for Counters.Counter;
  Counters.Counter private _tokenSupply;

  string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";
  string[] firstWords = ["Daft Punk", "Tom Petty", "Arcade Fire", "Real Estate", "My Morning Jacket", "Local Natives", "Fruits Bats", "Vampire Weekend",  "Pixies", "Portugal the Man"];

  event NewNFTMinted(address sender, uint256 tokenId);
  
  
  string public baseURI;
  string public baseExtension = ".json";
  uint256 public cost = 0.01 ether;
  uint256 public maxSupply = 1000;
  uint256 public amountToMint;
  bool public paused = false;
  
  //Mapping address whitelisted
  mapping(address => bool) public whitelisted;

  //Event
  event LogAmountToMint(uint newAmountToMint);

  constructor(
    string memory _name,
    string memory _symbol    
  ) ERC721(_name, _symbol) { 
    
  }

  // internal
  function _baseURI() internal view virtual override returns (string memory) {
    return baseURI;
  }

  // public
  

  //Mint
  function mint(address _to, uint256 _mintAmount) public payable {
    uint256 mintIndex = _tokenSupply.current() + 1;

    //Bonding curve 
    amountToMint = 2 * mintIndex + 9;
    emit LogAmountToMint(amountToMint);

    require(!paused);
    require(_mintAmount > 0, "The mint amount can't be 0.");
    require(_mintAmount <= amountToMint, "You can only mint:");
    require(mintIndex + _mintAmount <= maxSupply, "There are only:");

    
    // If not the owner, must pay the fee and must be whitelisted.
    if (msg.sender != owner()) {
        if(whitelisted[msg.sender] != true) {
          require(msg.value >= cost * _mintAmount);
        }
    }
    
    for (uint256 i = 0; i <= _mintAmount; i++) {
      _tokenSupply.increment();
      _safeMint(_to, _tokenSupply.current());
    }
  }

  //function walletOfOwner(address _owner)
  //  public
  //  view
  //  returns (uint256[] memory)
  // {
  //  uint256 ownerTokenCount = balanceOf(_owner);
  //  uint256[] memory tokenIds = new uint256[](ownerTokenCount);
  //  for (uint256 i; i < ownerTokenCount; i++) {
  //    tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
  //  }
  //  return tokenIds;
  //}

  function tokenURI(uint256 tokenId)
    public
    view
    virtual
    override
    returns (string memory)
  {
    require(
      _exists(tokenId),
      "ERC721Metadata: URI query for nonexistent token"
    );

    string memory currentBaseURI = _baseURI();
    return bytes(currentBaseURI).length > 0
        ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
        : "";
  }

  
  //Only owner
  
  function setCost(uint256 _newCost) public onlyOwner {
    cost = _newCost;
  }

  //function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
  //  maxMintAmount = _newmaxMintAmount;
  //}

  function setBaseURI(string memory _newBaseURI) public onlyOwner {
    baseURI = _newBaseURI;
  }

  function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
    baseExtension = _newBaseExtension;
  }

  function pause(bool _state) public onlyOwner {
    paused = _state;
  }
 
 function whitelistUser(address _user) public onlyOwner {
    whitelisted[_user] = true;
  }
 
  function removeWhitelistUser(address _user) public onlyOwner {
    whitelisted[_user] = false;
  }

  function withdraw() public payable onlyOwner {
    require(payable(msg.sender).send(address(this).balance));
  }


}