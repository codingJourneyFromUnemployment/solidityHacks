// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/*
EtherStore is a contract where you can deposit and withdraw ETH.
This contract is vulnerable to re-entrancy attack.
let's see why.

1. Deploy EtherStore
2. Deposit 1 Ether each from Account 1 (Alice) and Account 2 (Bob) into EtherStore
3. Deploy Attack with address of EtherStore
4. Call Attack.attack sending 1 ether (using Account 3 (Eve)).
    You will get 3 Ethers back (2 Ether stolen from Alice and Bob, plus 1 Ether sent from this contract).

What happened?
Attack was able to call EtherStore.withdraw multiple times
before EtherStore.withdraw finished executing.

Here is how the function were called
- Attack.attack
- EtherStore.deposit
- EtherStore.withdraw
- Attack fallback (receives 1 Ether)
- EtherStore.withdraw
- Attack.fallback (receives 1 Ether)
- EtherStore.withdraw
- Attack fallback (receives 1 Ether)
*/

contract EtherStore {

}

contract Attack {

}