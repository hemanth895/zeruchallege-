// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract DAI is ERC20 {
    constructor() ERC20("Dai Stablecoin", "DAI") {
        _mint(msg.sender, 1000000 * 10 ** decimals());
    }

    //0xd8b934580fcE35a11B58C6D73aDeE468a2833fa8
    //0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
}

contract ARB is ERC20 {
    constructor() ERC20("Arbitrum Token", "ARB") {
        _mint(msg.sender, 1000000 * 10 ** decimals());
    }

    //0xf8e81D47203A594245E36C48e151709F0C19fBe8
    //0x5B38Da6a701c568545dCfcB03FcB875f56beddC4
}
