// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// Signing messages off-chain and having a contract that requires that signature before executing a function is a useful technique.

// For example this technique is used to:

// reduce number of transaction on chain
// gas-less transaction, called meta transaction
// Vulnerability
// Same signature can be used multiple times to execute a function. This can be harmful if the signer's intention was to approve a transaction once.



import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

// contract MultiSigWallet {
//   using ECDSA for bytes32;

//   address[2] public owners;

//   constructor(address[2] memory _owners) {
//     owners = _owners;
//   }

//   function deposit() external payable {}

//   function transfer(
//     address _to,
//     uint _amount,
//     bytes[2] memory _sigs
//   ) external {
//     bytes32 txHash = getTxHash(_to, _amount);
//     require(_checkSigs(_sigs, txHash), "Invalid signatures");

//     (bool sent, ) = _to.call{value: _amount}("");
//     require(sent, "Failed to send Ether");
//   }

//   function getTxHash(
//     address _to,
//     uint _amount
//   ) public view returns (bytes32) {
//     return keccak256(abi.encodePacked(_to, _amount));
//   }

//   function _checkSigs(
//     bytes[2] memory _sigs,
//     bytes32 _txHash
//   ) private view returns (bool) {
//     bytes32 ethSignedHash = _txHash.toEthSignedMessageHash();

//     for (uint i = 0; i < _sigs.length; i++) {
//       address signer = ethSignedHash.recover(_sigs[i]);
//       bool valid = signer == owners[i];

//       if (!valid) {
//         return false;
//       }
//     }

//     return true;
//   }

// }

// Preventative Techniques
// Sign messages with nonce and address of the contract.

contract MultiSigWallet {
  using ECDSA for bytes32;

  address[2] public owners;
  mapping(bytes32 => bool) public executed;

  constructor(address[2] memory _owners) {
    owners = _owners;
  }

  function deposit() external payable {}

  function getTxHash(
    address _to,
    uint _amount,
    uint _nonce
  ) public view returns (bytes32) {
    return keccak256(abi.encodePacked(address(this), _to, _amount, _nonce));
  }

  function _checkSigs(
    bytes[2] memory _sigs,
    bytes32 _txHash
  ) private view returns (bool) {
    bytes32 ethSignedHash = _txHash.toEthSignedMessageHash();

    for (uint i = 0; i < _sigs.length; i++) {
      address signer = ethSignedHash.recover(_sigs[i]);
      bool valid = signer == owners[i];

      if (!valid) {
        return false;
      }
    }

    return true;
  }
}