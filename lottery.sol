//SPDX-License-Identifier: MIT

pragma solidity 0.8.13;

contract LotteryContract {
    address public owner;
    address payable[] public players;
    uint public lotteryId;
    mapping (uint => address payable) public lotteryHistory; 

    constructor() {
        owner = msg.sender;
        lotteryId = 1;
    }

    function getWinnerByLottery(uint _lotteryId) public view returns (address payable) {
        return lotteryHistory[_lotteryId];
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    function getPlayers() public view returns (address payable[] memory){
        return players;
    }

    function enter() public payable {
        require(msg.value > 0.01 ether);
        // address of player entering lottery
        players.push(payable(msg.sender));    
    }

    function getRandomNum() public view returns (uint){
        return uint(keccak256(abi.encodePacked(owner, block.timestamp)));
    }

    function pickWinner() public onlyOwner {
        uint index = getRandomNum() % players.length;
        players[index].transfer(address(this).balance);


        lotteryHistory[lotteryId] = players[index];
        lotteryId++; //change state of contract after transfer

        // reset the state of contract
        players = new address payable[](0);
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
}
