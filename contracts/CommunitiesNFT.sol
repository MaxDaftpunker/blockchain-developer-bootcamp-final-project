// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;


import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";


/// Import helper functions needed for Base64 encoding.
import { Base64 } from "./libraries/Base64.sol";


/// @title A Community Aggregator
/// @author Maximiliano Grub
/// @notice Allows communities to mint NFTs based on a bonding curve
/// @dev A better implementacion would be an ERC115 token, for gas optimization and 
contract CommunitiesNFT is ERC721, ERC721URIStorage, Ownable {
  
  using Strings for uint256;

  using Counters for Counters.Counter;
  Counters.Counter private _tokenIds;

  bool public paused = false;


  /// @dev The cost in Eth per NFT
  uint256 public cost = 0.001 ether;


  /// @dev The max amount of tokens that can be minted
  uint256 public maxSupply = 10000;
  
  
  /// @dev Track the number of times the "mint" function has been called 
  uint256 private countMinting = 0;

  string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";
  string[] words = ["Daft Punk", "Tom Petty", "Arcade Fire", "Real Estate", "My Morning Jacket", "Local Natives", "Fruits Bats", "Vampire Weekend",  "Pixies", "Portugal the Man"];
  

  /// @notice Event to be emitted after minting all the NFTs
  /// @param sender The address of the transaction sender
  /// @param amountNftMinted The amount of NFTs minted
  event finishTheMinting(address sender, uint256 amountNftMinted);


  /// @notice Event to be emitted after a successful mint
  /// @param sender The address of the transaction sender
  /// @param tokenId The id of the token that has just been minted
  event NewNFTMinted(address sender, uint256 tokenId);
  

  /// @notice Event to be emitted after the call of the bonding curve  
  /// @param newAmountToMint The amount that the sender can mint
  event LogAmountToMint(uint256 newAmountToMint);
  

  /// @notice Mapping address whitelisted
  mapping(address => bool) public whitelisted;

  
  /// @notice contract constructor. Takes parameters and passes them to the inherited ERC721 contract constructor
  /// @param _name the name of the contract
  /// @param _symbol the symbol that contract tokens will be represented by
  constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol) {
    // Increments the counter so that it starts with Id:1
      _tokenIds.increment();
  }

  /// @notice Pick a random word to name the nft
  /// @dev The randomness could be improved 
  function pickRandomWord(uint256 tokenId) public view returns (string memory) {
    uint256 rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));
    rand = rand % words.length;
    return words[rand];
  }

  /// @param input string input which is hashed to generate the 'random' number.
  /// @return A random integer
  function random(string memory input) internal pure returns (uint256) {
    return uint256(keccak256(abi.encodePacked(input)));
  }

  /// @notice Returns the amount of NFTs to minte  
  /// @dev 
  function tokensMinted() public view returns (uint256) {
    return _tokenIds.current();
  }

  /// @notice Returns the amount of NFTs to minte  
  /// @dev 
  
  function bondingCurve() internal returns (uint256) {
    uint256 amountToMint = 2 * countMinting + 4;
    emit LogAmountToMint(amountToMint);
    return amountToMint;  
  }
    
  
  /// @notice Mint a quantity of ERC721 determined by the bonding curve.  All are randomly selected.  
  /// @dev currently does not accept payment
  /// @dev this function creates and stores the tokens URI. This is a JSON string constisting of name, description and image fields. The image is a BASE64 encoded SVG. Finally The whole JSON metadata string is BASE64 encoded and mapped to the tokenId.
  function mint() public payable {
    uint256 mintAmount = bondingCurve();
    uint256 newItemId = _tokenIds.current(); 

    require(!paused);
    require(_tokenIds.current() + mintAmount <= maxSupply, "There is no more NFTs to mint");
    
    
    /// If not the owner, must pay the fee and must be whitelisted.
    if (msg.sender != owner()) {
        if(whitelisted[msg.sender] != true) {
          require(msg.value >= cost * mintAmount);
        }
    }
           
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
    
    
    /// For
    for (uint256 i = 1; i <= mintAmount; i++) {
      newItemId = _tokenIds.current();

      
      // Increment the counter for when the next NFT is minted
      _tokenIds.increment();


      // Mint the NFT
      _safeMint(msg.sender, newItemId);


      // Store the tokens metadata.
      _setTokenURI(newItemId, finalTokenUri);

      
      emit NewNFTMinted(msg.sender, newItemId);
    }

    
    emit finishTheMinting(msg.sender, mintAmount);
    
    countMinting += 1;  
    
  }


  ///Only owner functions


  /// @notice Change the cost of the minting
  /// @dev Only the contract owner can call this
  function setCost(uint256 _newCost) public onlyOwner {
    cost = _newCost;
  }

    
  /// @notice Pause the contract
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

  
  // The following functions are overrides required by Solidity.

  function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
      super._burn(tokenId);
  }

  function tokenURI(uint256 tokenId)
      public
      view
      override(ERC721, ERC721URIStorage)
      returns (string memory)
  {
      return super.tokenURI(tokenId);
  }
}