// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.0 <0.9.0;

import "./newtoken.sol";
import "./owner.sol";

contract TokenBank is Owner{
    NewToken ntoken;
    
    uint private interestRatePerYear;
    uint private timeTillDeposit;
    
    mapping (address => uint256) private DepositBalance; 
    mapping (address => bool) private isDeposit;
    mapping (address => uint) private startTime;
    
    constructor() public{
        interestRatePerYear = 10;
         timeTillDeposit = 365 days;
    }
    
    function SetTokenContractAddress(address _address) external isOwner{   
        ntoken = NewToken(_address);
    }
    
    function ChangeInterestRate (uint _interestRate) external isOwner{
        interestRatePerYear = _interestRate;
    }
    
    function ChangeTimeTillDeposit (uint _timeTillDeposit) external isOwner{
        timeTillDeposit = _timeTillDeposit;
    }
    
    modifier WithDrawPeriod (uint sTime){
        require(block.timestamp >= sTime + timeTillDeposit, "Deposit period not ended");
        _;
    }
    
    modifier HavingDeposit(){
        require(isDeposit[msg.sender], "You done have any deposit in the bank");
        _;
    }
    
    function DepositToken(uint _ammount) external {
        ntoken.approve(address(this), _ammount);
        ntoken.transferFrom(msg.sender, address(this), _ammount);
        
        DepositBalance[msg.sender] += _ammount;
        
        isDeposit[msg.sender] = true;
        startTime[msg.sender] = block.timestamp;
        
    }
    
    function WithdrawToken() external HavingDeposit() WithDrawPeriod (startTime[msg.sender]){
        uint balance = DepositBalance[msg.sender];
        
        require(balance > 0, "staking balance can not be 0");
        
        uint period = block.timestamp - startTime[msg.sender];
        
        uint result = balance * (1 + ((interestRatePerYear * period) /100 ) / 365 days);
        
        ntoken.transfer(msg.sender, result);
        
        DepositBalance[msg.sender] = 0;
        startTime[msg.sender] = 0;
        isDeposit[msg.sender] = false;
    }
     
    
}