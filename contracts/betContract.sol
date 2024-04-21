// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BettingDApp {
    address public owner;

    struct Bet {
        address user;
        uint amount;
        uint8 team; // 0 for Team A, 1 for Team B
    }

    mapping(uint8 => uint) public totalAmountBet;
    mapping(uint8 => uint) public numberOfBets;
    mapping(address => Bet) public bets;

    event BetPlaced(address indexed user, uint amount, uint8 team);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function.");
        _;
    }

    function bet(uint8 _team) external payable {
        require(_team == 0 || _team == 1, "Invalid team selection.");
        require(msg.value > 0, "Bet amount must be greater than 0.");

        uint currentBetAmount = bets[msg.sender].amount;
        require(currentBetAmount == 0, "You have already placed a bet.");

        bets[msg.sender] = Bet(msg.sender, msg.value, _team);
        totalAmountBet[_team] += msg.value;
        numberOfBets[_team]++;

        emit BetPlaced(msg.sender, msg.value, _team);
    }

    function distributePrizes(uint8 winningTeam) external onlyOwner {
        require(winningTeam == 0 || winningTeam == 1, "Invalid team selection.");

        uint totalBetAmount = totalAmountBet[0] + totalAmountBet[1];
        uint winningBetAmount = totalAmountBet[winningTeam];

        for (uint8 i = 0; i < 2; i++) {
            if (i == winningTeam) {
                // Pay out winners
                for (uint j = 0; j < numberOfBets[i]; j++) {
                    address winner = bets[msg.sender].user;
                    uint betAmount = bets[msg.sender].amount;
                    payable(winner).transfer((betAmount * totalBetAmount) / winningBetAmount);
                }
            }
            // Reset bets
            totalAmountBet[i] = 0;
            numberOfBets[i] = 0;
        }
    }

    function withdraw() external {
        uint amount = bets[msg.sender].amount;
        require(amount > 0, "No winnings to withdraw.");
        bets[msg.sender].amount = 0;
        payable(msg.sender).transfer(amount);
    }
}
