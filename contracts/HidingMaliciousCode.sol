// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/*
Let's say Alice can see the code of Foo and Bar but not Mal.
It is obvious to Alice that Foo.callBar() exxcutes the code inside Bar.log().
However Eve deploys Foo with the address of Mal, so that calling Foo.callBar()
will actually execute the code at Mal.
*/

/*
1. Eve deploys Mal
2. Eve deploys Foo with the address of Mal
3. Alice calls Foo.callBar() after reading the code and judging that it is safe to call.
4. Although Alice expected Bar.log() to be execute, Mal.log() was executed.
*/

contract Bar {
  event Log(string message);

  function log() public {
    emit Log("Bar was called");
  }
}

contract Foo {
  Bar public bar;

  constructor(address _bar) {
    bar = Bar(_bar);
  }

  function callBar() public {
    bar.log();
  }
}

//This code is hidden in a different file
contract Mal {
  event Log(string message);

  // function () external {
  //   emit Log("Mal was called");
  // }

  // Actually we can execute the same exploit even if this function dose not exist by using the fallback function

  function log() public {
    emit Log("Mal was called");
  }
}

//Preventative Techniques

// Bar public bar;

// constructor() public {
//     bar = new Bar();
// }