Design Pattern Decisions
Access Control Design Patterns

The Ownable design pattern has been implemented to give only the contract owner permission to pause and unpause the contract.
Inheritance and Interfaces

The contract inherits from multiple parent contracts:

    ERC721: The standard interface for non-fungable tokens.
    ERC721Enumerable: Extends the ERC721 contract by adding enumerability of all the token ids in the contract as well as all token ids owner by each account. Provides additional functions: totalSupply(), tokenByIndex() and tokenOfOwnerByIndex()
    ERC721URIStorage: provides support for storing token URIs.
    Pausable: Allows the contract to be paused in an emergency whilst a remidiation is pending.
    Ownable: Creates a single 'owner' role, which works for a simple project like this. However as a project grows in complexity, it's recommended to look at changing this to use the AccessControl module to create more granular roles.
