// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/*
Alice creates a guessing game.
You win 10 ether if you can find the correct string that hashes to the target hash.
Let's see how this contract is vulnerable to front running.
*/

/*
1. Alice deploys FindThisHash with 10 ether.
2. Bob finds the correct string that will hash to the target hash. ("Ethereum")
3. Bob calls solve("Ethereum") with gas price set to 15 gwei.
4. Eve is watching the transaction pool for the answer to be submitted.
5. Eve sees Bob's answer and calls solve("Ethereum") with higher gas price than Bob.(100 gwei)
6. Eve's transaction was mined before Bob's transaction.
7. Eve wins 10 ether.
*/

contract FindThisHash{
  bytes32 public constant hash = 0x564ccaf7594d66b1eaaea24fe01f0585bf52ee70852af4eac0cc4b04711cd0e2;

  constructor() payable {}

  function solve(string memory solution) public {
    require(hash == keccak256(abi.encodePacked(solution)), "Incorrect solution");

    (bool sent, ) = msg.sender.call{value: 10 ether}("");
    require(sent, "Failed to send Ether");
  }
}

// Now Let's see how to guard from front running using commit reveal scheme.

/*
1. Alice deploys SecuredFindThisHash with 10 ether.
2. Bob finds the correct string that will hash to the target hash. ("Ethereum").
3. Bob then finds the keccak256(Address in lowercase + Solution + Secret). 
Address is his wallet address in lowercase, solution is "Ethereum", Secret is like an password ("mysecret") that only Bob knows which Bob uses to commit and reveal the solution.
keccak2566("0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266Ethereummysecret") = '0xf95b1dd61edc3bd962cdea3987c6f55bcb714a02a2c3eb73bd960d6b4387fc36'
4. Bob then calls commitSolution("0xf95b1dd61edc3bd962cdea3987c6f55bcb714a02a2c3eb73bd960d6b4387fc36"), 
  where he commits the calculated solution hash with gas price set to 15 gwei.
5. Eve is watching the transaction pool for the answer to be submitted.
6. Eve sees Bob's answer and he also calls commitSolution("0xf95b1dd61edc3bd962cdea3987c6f55bcb714a02a2c3eb73bd960d6b4387fc36")
  with a higher gas price than Bob (100 gwei).
7. Eve's transaction was mined before Bob's transaction, but Eve has not got the reward yet.
  He needs to call revealSolution() with exact secret and solution, so lets say he is watching the transaction pool to front run Bob as he did previously
8. Then Bob calls the revealSolution("Ethereum", "mysecret") with gas price set to 15 gwei;
9. Let's consider that Eve's who's watching the transaction pool, find's Bob's reveal solution transaction and he also calls 
  revealSolution("Ethereum", "mysecret") with higher gas price than Bob (100 gwei)
10. Let's consider that this time also Eve's reveal transaction was mined before Bob's transaction, but Eve will be
  reverted with "Hash doesn't match" error. Since the revealSolution() function checks the hash using 
  keccak256(msg.sender + solution + secret). So this time eve fails to win the reward.
11. But Bob's revealSolution("Ethereum", "mysecret") passes the hash check and gets the reward of 10 ether.
*/

contract SecuredFindThisHash {
  //struct is used to store the commit details
  struct Commit {
    bytes32 solutionHash;
    uint commitTime;
    bool revealed;
  }

  // The hash that is needed to be solved
  bytes32 public hash = 0x564ccaf7594d66b1eaaea24fe01f0585bf52ee70852af4eac0cc4b04711cd0e2;

  // Address of the winner
  address public winner;

  // Price to be rewarded
  uint public reward;

  // Status of game
  bool public ended;

  // Mapping to store the commit details with address
  mapping(address => Commit) public commits;

  // Modifier to check if the game is active
  modifier gameActive() {
    require(!ended, "Game has ended");
    _;
  }

  constructor() payable {
    reward = msg.value;
  }

  /* 
      Commit function to store the hash calculated using keccak256(address in lowercase + solution + secret). 
      Users can only commit once and if the game is active.
  */

  function commitSolution(bytes32 _solutionHash) public gameActive {
    Commit storage commit = commits[msg.sender];
    require(commit.commitTime == 0, "Already committed");
    commit.solutionHash = _solutionHash;
    commit.commitTime = block.timestamp;
    commit.revealed = false;
  }

  
}
