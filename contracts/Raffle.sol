// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import '@chainlink/contracts/src/v0.8/vrf/VRFConsumerBaseV2.sol';
import '@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol';

error Raffle_NotEnoughEntered();

contract Raffle is VRFConsumerBaseV2 {
    /* State variables */
    uint256 private immutable i_enteranceFee;
    address payable[] private s_players;
    VRFCoordinatorV2Interface private immutable i_vrfCoordinator;
    bytes32 private immutable i_gasLane;
    uint64 private immutable i_subscriptionId;
    uint32 private immutable i_callBackGasLimit;
    uint32 private constant NUM_WORDS = 1;
    uint16 private constant REQUEST_CONFRIMATIONS = 3;


    /* Events */
    event RaffleEnter(address indexed player);
    event RequestRaffleWinner(uint256 indexed requestId);

    constructor(
        address vrfCoordinatorV2,
        uint256 enteranceFee,
        bytes32 gasLane,
        uint64 subscriptionId,
        uint32  callBackGasLimit
    ) VRFConsumerBaseV2(vrfCoordinatorV2) {
        i_enteranceFee = enteranceFee;
        i_vrfCoordinator = VRFCoordinatorV2Interface(vrfCoordinatorV2);
        i_gasLane = gasLane;
        i_subscriptionId = subscriptionId;
        i_callBackGasLimit = callBackGasLimit;
    }

    function enterRaffle() public payable {
        // require (msg.value > i_enteranceFee), "not gas" npx hardhat compile
        if (msg.value < i_enteranceFee) {
            revert Raffle_NotEnoughEntered();
        }
        s_players.push(payable(msg.sender));
        // Event when we update
        emit RaffleEnter(msg.sender);
    }

    function requestRandomWinner() external {

        uint256 requestId = i_vrfCoordinator.requestRandomWords(
            i_gasLane, /* keyHash  */
            i_subscriptionId,
            REQUEST_CONFRIMATIONS,
            i_callBackGasLimit,
            NUM_WORDS
        );
        emit RequestRaffleWinner(requestId)
    }

    function fulfillRandomWords(
        uint256 requestId,
        uint256[] memory randomWords
    ) internal override {}

    /*  View/Pure function */
    function getEntranceFee() public view returns (uint256) {
        return i_enteranceFee;
    }

    function getPlayer(uint256 index) public view returns (address) {
        return s_players[index];
    }
}
