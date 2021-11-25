// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;


import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

// Import helper functions needed for Base64 encoding.
import { Base64 } from "./libraries/Base64.sol";


/// @title A Community Aggregator
/// @author Maximiliano Grub
/// @notice Allows comunities to mint some NFTs
/// @dev  
contract CommunitiesNFT is ERC721URIStorage, Ownable {
  using Strings for uint256;
  
  uint256 public cost = 0.01 ether;
  uint256 public maxSupply = 10000;
  bool public paused = false;
  
  // @notice Track of token ids using purpose built OpenZeppelin utility
  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;


  string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";
  string[] words = ["Daft Punk", "Tom Petty", "Arcade Fire", "Real Estate", "My Morning Jacket", "Local Natives", "Fruits Bats", "Vampire Weekend",  "Pixies", "Portugal the Man"];
  
  // @notice Event to be emitted after a successful mint
  // @param sender The address of the transaction sender
  // @param tokenId The id of the token that has just been minted
  event NewNFTMinted(address sender, uint256 tokenId);
  
  // @notice Event to be emitted after a successful mint
  // @param sender The address of the transaction sender
  // @param tokenId The id of the token that has just been minted
  event LogAmountToMint(uint256 newAmountToMint);
  
  
  
  //Mapping address whitelisted
  mapping(address => bool) public whitelisted;

  
  /// @notice contract constructor. Takes parameters and passes them to the inherited ERC721 contract constructor
  /// @param _name the name of the contract
  /// @param _symbol the symbol that contract tokens will be represented by
  constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol) {}

  /// @notice pick a random word to name the nft
  /// @dev the randomness could be improved 
  function pickRandomWord(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));
    rand = rand % words.length;
    return words[rand];
  }

  function random(string memory input) internal pure returns (uint256) {
      return uint256(keccak256(abi.encodePacked(input)));
  }

  
  /// @notice Returns the amount of nft 
  /// @dev 
  
  function bondingCurve() internal returns (uint256) {
    uint256 amountToMint = 2 * _tokenIds.current() + 10;
    emit LogAmountToMint(amountToMint);
    return amountToMint;  
  }
    
  
  /// @notice Mint an ERC721 token on the contract. 
  /// @dev 
  function mint(address _to) public payable {
    require(!paused);
    require(_tokenIds.current() + bondingCurve() <= maxSupply, "You can only mint:");
    require(whitelisted[msg.sender], "No ");
    
    uint256 mintAmount = bondingCurve(); 

    // If not the owner, must pay the fee and must be whitelisted.
    if (msg.sender != owner()) {
        if(whitelisted[msg.sender] != true) {
          require(msg.value >= cost * mintAmount);
        }
    }
    
    uint256 newItemId = _tokenIds.current();
     
   
    // For
    for (uint256 i = 0; i <= mintAmount; i++) {
      string memory first = pickRandomWord(newItemId);

      string memory finalSvg = string(abi.encodePacked(baseSvg, first, "</text></svg>"));

      // Get all the JSON metadata in place and base64 encode it.
      string memory json = Base64.encode(
         bytes(
            string(
                abi.encodePacked(
                    '{"name": "',first, 
                    '", "description": "A Crypto Communities NFT", "image": "data:image/svg+xml;base64,',
                    // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                    Base64.encode(bytes(finalSvg)),
                    '"}'
                )
            )
          )
        );

      // Just like before, we prepend data:application/json;base64, to our data.
      string memory finalTokenUri = string(
          abi.encodePacked("data:application/json;base64,", json)
      );


      _safeMint(msg.sender, newItemId);

      // Store the tokens metadata.
      _setTokenURI(newItemId, finalTokenUri);

      // Increment the counter for when the next NFT is minted
      _tokenIds.increment();
    }
    emit NewNFTMinted(msg.sender, newItemId); 
    
  }

  ///Only owner functions

  /// @notice Change the cost of the minting
  /// @dev Only the contract owner can call this
  function setCost(uint256 _newCost) public onlyOwner {
    cost = _newCost;
  }

  //function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
  //  maxMintAmount = _newmaxMintAmount;
  //}

  
  /// @notice Pause the minting
  /// @dev Only the contract owner can call this
  function pause(bool _state) public onlyOwner {
    paused = _state;
  }


  /// @notice Add a user to the whitelist
  /// @dev Only the contract owner can call this
  function whitelistUser(address _user) public onlyOwner {
    whitelisted[_user] = true;
  }


  /// @notice Remove a user from the whitelist 
  /// @dev Only the contract owner can call this
  function removeWhitelistUser(address _user) public onlyOwner {
    whitelisted[_user] = false;
  }


  /// @notice Withdraw contract funds
  /// @dev Only the contract owner can call this
  function withdraw() public payable onlyOwner {
    require(payable(msg.sender).send(address(this).balance));
  }


}