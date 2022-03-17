//SPDX-License-Identifier: MIT
    pragma solidity ^0.8.0;

    import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

    contract stakeToken is ERC20 {

        address public admin;

        constructor() ERC20('StakeCoin', 'STC') {
            _mint(msg.sender, 10^18);
        }

        //Stake
        struct stake_amount{
            uint amount;
            uint Timestamp;   
        }        

        uint staking_time;
        address[] internal stakeholders;
        mapping(address => stake_amount)internal stakes;
        mapping(address => uint) internal rewards;

        function checkStakeholder(address _address) public view returns(bool, uint256){
        for (uint s = 0; s < stakeholders.length; s += 1){
            if (_address == stakeholders[s]) return (true, s);
            }
        return (false, 0);
        }

        function addStakeholder(address _stakeholder, uint Stake_amount) internal {
        (Stake_amount > 0, "Stake amount cannot be zero");
        require(balanceOf(msg.sender) >= Stake_amount, "Low Balance" );

        (bool _isStakeholder, ) = checkStakeholder(_stakeholder);
        if(!_isStakeholder){
            stakeholders.push(_stakeholder);
            _burn(msg.sender, Stake_amount);
        } 

        }

        function removeStakeholder(address _stakeholder) internal
        {
        (bool _isStakeholder, uint256 s) = checkStakeholder(_stakeholder);
        if(_isStakeholder){
            uint reward = adder(rewards[_stakeholder], stakes[_stakeholder].amount);
            _mint(_stakeholder,reward);

        }
        }


        function holderReward(address _stakehldr) public view returns(uint){
        return rewards[_stakehldr];
        }

        function MyReward() public view returns(uint)
        {
        return rewards[msg.sender];
        }


        function adder(uint x, uint y) internal pure returns(uint){
            return x + y;
        } 
        
        function sub(uint x, uint y) internal pure returns(uint){
            return x - y;
        } 

        function startStake() public returns(uint){
            staking_time = block.timestamp;
            return staking_time;
            }
            
        function createStake(uint _stake) public {
        
            if(stakes[msg.sender].amount == 0) addStakeholder(msg.sender, _stake);
            
            stakes[msg.sender].amount = adder(stakes[msg.sender].amount,_stake);
                stakes[msg.sender].Timestamp = block.timestamp;

        }

        function removeStake(uint _stake) public{
            stakes[msg.sender].amount = sub(stakes[msg.sender].amount,_stake);
            if(stakes[msg.sender].amount == 0) removeStakeholder(msg.sender);
        }

        function mulDiv(uint _percent, uint _amount, uint z) internal pure returns(uint){
            return _percent * _amount/z;
        }
    
        function calculateReward(address holder) public view returns(uint ){
        uint period = (stakes[holder].Timestamp - staking_time) / 60 / 60 / 24;
           //uint amt = stak[msg.sender].amount;
        uint reward;
        if(period >= 30 || period < 60){
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

        function withdrawReward() public {
        uint reward = rewards[msg.sender];
        rewards[msg.sender] = 0;
        _mint(msg.sender, reward);
        }
    }
