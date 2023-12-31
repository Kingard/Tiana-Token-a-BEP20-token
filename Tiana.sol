
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

contract tiana{
    string _name = "Tiana Token";
    string _symbol = "TNA";
    uint _decimals = 18;
    uint _totalSupply = 1000000 * 10**18;
    mapping (address => uint) public balances;
    mapping (address => mapping(address=>uint)) public  allowance;

    // define our events: transfer and approval events
    event Transfer(address indexed from, address indexed to, uint amount);
    event Approval(address indexed  owner, address indexed spender, uint amount);


    // The constructor funtion is run only once on the deployment of the contract
    constructor(){
        // assign all tokens to the owner of the contract
        balances[msg.sender] = _totalSupply;

    }

    // totalSupply(): external ; The total supply of the tokens 
    function totalSupply() external view returns (uint){
        return _totalSupply;

    }

    // balanceOf(account): public ; balance of wallet associated with a given account
    function balanceOf(address account) public  view returns(uint){
        return balances[account];
    }

    // transfer(recipient, amount): external ; transfer of all or part of one's tokens to a different wallet
    function transfer(address _to, uint amount) external returns(bool){
        require(balanceOf(msg.sender) >= amount,"insufficient balance");
        // Adjust the balances to prevent double spending
        balances[_to] += amount;
        balances[msg.sender] -= amount;
        // emit an event: essential for logging
        emit Transfer(msg.sender,_to,amount);
        return true;
    }

    // approve(spender, amount): external ; *** to fill
    function approve(address spender, uint amount) public returns(bool){
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    // transferFrom(sender, recipient, amount): external ; usecase is delegated spending

    function transferFrom(address sender,address receiver,uint amount) public returns(bool){
        require(balanceOf(sender)>= amount, "insufficient funds!");
        require(allowance[msg.sender][sender]>=amount,"Not allowed to spend this amount");
        balances[receiver] += amount;
        balances[sender] -= amount;
        emit Transfer(sender, receiver, amount);
        return true;
    }

    // allowance(owner, spender): external ; amount a holder is allowed to spend?? ** not sure




}