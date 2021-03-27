pragma solidity ^0.8.0;
pragma abicoder v2;

//@notice Here is the import from openZeppelin library;
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

//@notice my contract inherits from Ownable;
contract Bank is Ownable {

    mapping(address => uint) balance;
    address[] customers;

    event depositDone(uint amount, address indexed depositedTo);

     //@ notice using SafeMath adding value;
    function deposit() public payable returns (uint)  {
        balance[msg.sender] = SafeMath.add(balance[msg.sender], msg.value);
        emit depositDone(msg.value, msg.sender);
        return balance[msg.sender];
    }

    //@ notice using SafeMath substracting value;
    function withdraw(uint amount) public onlyOwner returns (uint){
        require(balance[msg.sender] >= amount);
        balance[msg.sender] = SafeMath.sub(balance[msg.sender], amount);
        payable(msg.sender).transfer(amount);
        return balance[msg.sender];
    }

    function getBalance() public view returns (uint){
        return balance[msg.sender];
    }

    function transfer(address recipient, uint amount) public payable {
        require(balance[msg.sender] >= amount, "Balance not sufficient");
        require(msg.sender != recipient, "Don't transfer money to yourself");

        uint previousSenderBalance = balance[msg.sender];

        _transfer(msg.sender, recipient, amount);

        assert(balance[msg.sender] == previousSenderBalance - amount);
    }

    //@notice continuing using our library;
    function _transfer(address from, address to, uint amount) private {
        balance[from] = SafeMath.sub(balance[from], amount);
        balance[to] = SafeMath.add(balance[to], amount);
    }

}
