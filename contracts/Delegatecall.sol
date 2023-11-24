// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/*
HackMe is a contract that usess delegatecall to execute code.
It is not obvious that the owner of HackMe can be changed since there is no
function inside HackkMe to do so. However an attacker can hijack the contract
by exploiting delegatecall. Let's see how.


*/