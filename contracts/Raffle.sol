// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

error Raffle_NotEnoughtEhernted();

contract Raffle {
    // State variables
    uint256 private immutable i_enteranceFee;
    address payable[] private s_players;

    constructor(uint256 enteranceFee) {
        i_enteranceFee = enteranceFee;
    }

    function enterRaffle() public payable {
        // require (msg.value > i_enteranceFee), "not gas"

        if (msg.value < i_enteranceFee) {
            revert Raffle_NotEnoughtEhernted();
        }

        s_players.push(payable(msg.sender));
        // Event when we update
    }

    function getEntranceFee() public view returns (uint256) {
        return i_enteranceFee;
    }

    function getPalyer(uint256 index) public view returns (address) {
        return s_players[index];
    }
}
