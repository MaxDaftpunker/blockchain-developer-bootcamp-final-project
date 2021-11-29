# Avoiding Common Attacks

## Floating pragma

Specific compiler pragma `0.8.0` used in contracts to avoid accidental bug inclusion through outdated compiler versions.

## Unprotected Ether Withdrawal

`setCost`, `pause`, `whitelistUser`, `removeWhitelistUser` and `withdraw` are protected with OpenZeppelin `Ownable`'s `onlyOwner` modifier.

