# Avoiding Common Attacks

## Floating pragma (SWC-103)

Specific compiler pragma `0.8.0` used in contracts to avoid accidental bug inclusion through outdated compiler versions.

## Unprotected Ether withdrawal (SWC-105)

`withdraw` are protected with OpenZeppelin `Ownable`'s `onlyOwner` modifier.

