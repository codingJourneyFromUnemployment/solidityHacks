// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/*
The goal of KingOfEther is to become the king by sending more Ether than 
the previous king. Previous King will be refuned with the amount of Ether he sent.
*/

/*
1. Deploy KingOfEther
2. Alice becomes the king by sending 1 Ether to claimThrone()
3. Bob becomes the king by sending 2 Ether to claimThrone()
  Alice receives a refund of 1 Ether
4. Deploy Attack with address of KingOfWther
5. Call attack with 3 Ether
6. Current King is the Attack contract and no one can become the new king.

What happened?
Attack became the king. All new challenge to claim the throne will be rejected since Attack contract does not have a fallback function, denying to accept the Ether sent from KingOfEther before the new King is set.
*/

