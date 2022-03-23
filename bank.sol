pragma solidity 0.8.13;

contract bankContract{
    mapping(address => uint) private balances;

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw(address payable addr, uint amount) public payable {
        require(balances[addr] >= amount, "Insuffient Funds!");
        (bool sent, bytes memory data) = addr.call{value: amount}("");
        require(sent, "Could not withdraw!");
        balances[msg.sender] -= amount;
    }

    function getBalance() public view returns (uint){
        return address(this).balance;
    }

}
