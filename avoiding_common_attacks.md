Avoiding Common Attacks
Specific Compiler Pragma

The contract code in this project uses a specific compiler version: 0.8.0
Proper use of require

The contract makes use of a modifier supplied by the Ownable module.

require(owner() == _msgSender(), "Ownable: caller is not the owner")

Require() is also used in the contract constructor to ensure that the supplyCap field is set correctly.

require(_supplyCap > 0, "supplyCap must be greater than 0");

In both these cases require() is used to test a transaction input. It acts as a gate condition that, when not met, prevents further execution, produces an error and refunds any unused gas.
Use Modifiers Only for Validations

The onlyOwner modifier only does validation on the message sender. There are no external calls within it.
Proper use of .call

Both the withdrawAllFunds() and withdrawFunds() functions make use of .call() rather than transfer() or send() as this avoids the fixed gas limit of 2300 imposed by the transfer/send functions.