// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/*
Note: cannot use web3 on JVM, so use the contract deployed on Goerli
Note: browser web3 is old so use web3 from truffle console

Contract deployed on Goerli:
0x534E4Ce0ffF779513793cfd70308AF195827BD31
*/

/*
# Storage
- 2 ** 256 slots
- 32 bytes per slot
- data is stored sequentially in the order of declaration
- storage is optimized to save space. If neighboring variables fit in a single slot, then they are packed into the same slot, starting from the right
*/

contract Vault {
  // slot 0
  uint public count = 123;
  // slot 1
  address public owner = msg.sender;
  bool public isTrue = true;
  uint16 public u16 = 31;
  // slot 2
  bytes32 private password;

  // constants do not use storage
  uint public constant someConst = 123;

  // slot 3, 4, 5 (one for each array element)
  bytes32[3] public data;

  struct User {
    uint id;
    bytes32 password;
  }

  // slot 6 - length of array
  // starting from slot hash(6) - array elements
  // slot where array element is stored = keccak256(slot) + (index * elementSize)
  // Where slot = 6 and elementSize = 2 (1(uint) + 1(bytes32))
  User[] private users;

  // slot 7 - empty
  // entries are stored at hash(key, slot)
  // where slot = 7, key = map key
  mapping(uint => User) public idToUser;

  constructor(bytes32 _password) {
    password = _password;
  }

  
}