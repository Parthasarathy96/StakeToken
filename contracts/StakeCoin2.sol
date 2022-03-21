//SPDX-License-Identifier: MIT
    pragma solidity ^0.8.0;

    import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
    
    contract stakeToken is ERC20 {

         constructor() ERC20('StakeCoin', 'STC') {
            _mint(msg.sender, 1000*8);
        }

//Stake
        struct stake_amount{
            uint amount;
            uint Timestamp;   
        }        

        address[] internal stakeholders;
        mapping(address => stake_amount)internal stakes;
        mapping(address => uint) internal rewards;

//CHECK STAKEHOLDER
        function checkStakeholder(address _address) public view returns(bool, uint256){
        for (uint s = 0; s < stakeholders.length; s += 1){
            if (_address == stakeholders[s]) return (true, s);
            }
        return (false, 0);
        }

//ADD STAKE
        function addStake(uint _amount) public {
            require(balanceOf(msg.sender) >= _amount, "Low STC coin");
            stakeholders.push(msg.sender);
            _burn(msg.sender, _amount);
            stakes[msg.sender].amount += _amount;
            stakes[msg.sender].Timestamp = block.timestamp; 
        }
//SUBTRACT
        function sub(uint x, uint y) internal pure returns(uint){
            return x - y;
        } 
//ADD
        function adder(uint x, uint y) internal pure returns(uint){
            return x + y;
        } 

//Remove Stakeholder
        function removeStakeholder(address _stakeholder) internal
        {
        (bool _isStakeholder, uint s) = checkStakeholder(_stakeholder);
        if(_isStakeholder){
         stakeholders[s] = stakeholders[stakeholders.length - 1];
         stakeholders.pop();
            stakeholders.pop();
        }
        }

//REMOVE STAKE
        function removeStake(uint _stake) public{
            require(_stake != 0, "Invalid stake amount");
            require(stakes[msg.sender].amount >= _stake, "Invalid stake amount");
            stakes[msg.sender].amount = sub(stakes[msg.sender].amount ,_stake);
            _mint(msg.sender, _stake);
            if(stakes[msg.sender].amount == 0) removeStakeholder(msg.sender);
        }   

//CHECK MY REWARD
        function MyReward() public view returns(uint)
        {
        return rewards[msg.sender];
        }

//PERCENTAGE FINDER
        function mulDiv(uint _percent, uint _amount, uint z) internal pure returns(uint){
            return _percent * _amount/z;
        }

//CALCULATE REWARD
        function calculateReward(address holder) public view returns(uint ){
        //uint period = (stakes[holder].Timestamp - block.timestamp) / 60 / 60 / 24;
        uint period = (stakes[holder].Timestamp - block.timestamp) / 60 ;
        uint reward;
        if(period >= 2 || period < 60){
            reward = mulDiv (15, stakes[holder].amount, 10^8);
        }else if(period >= 60 || period < 90){
            reward = mulDiv (30, stakes[holder].amount, 10^8);
        }else if(period >= 90){
            reward = mulDiv (45, stakes[holder].amount, 10^8);
        }
        return reward;
    }

        function distributeRewards() public {
        for (uint s = 0; s < stakeholders.length; s += 1){
        address stakeholder = stakeholders[s];
        uint reward = calculateReward(stakeholder);
        rewards[stakeholder] = adder(rewards[stakeholder], reward);
            }
        }



//WITHDRAW REWARDS
        function withdrawReward() public { 
        require(rewards[msg.sender] != 0, "No Reward available");
        uint reward = rewards[msg.sender];
        rewards[msg.sender] = 0;
        _mint(msg.sender, reward);
        }

    }
