# Design patterns Decisions

## Access Control Design Patterns

The `Ownable` design pattern has been implemented to give only the contract owner permission to pause and unpause the contract.

## Inheritance and Interfaces

`CommunitiesNFT` contract inherits the OpenZeppelin `Ownable` (Creates a single 'owner' role), `ERC721` (The standard interface for non-fungable tokens) and `ERC721URIStorage` (provides support for storing token URIs.) parents contracts.