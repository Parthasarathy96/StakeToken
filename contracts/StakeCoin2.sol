    //SPDX-License-Identifier: MIT
    pragma solidity ^0.8.0;

    contract stakeToken {
        address public owner;
    //Events
        event TransferE(address indexed from, address indexed to, uint tokens);
        event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
        event Stake_List(address indexed user, uint amount, uint index, uint timestamp);

    //Token Profile
        string public constant name = "StakeCoin";
        string public constant Symbol = "STC";
        uint8 public constant decimals = 18;


    //Token Holder
        mapping(address => uint) balances;
        mapping(address => mapping(address => uint)) allowed;
        uint totalSupply;

    //Stake
        struct stake_amount{
            uint amount;
            uint Timestamp;   
        }        

        uint staking_time;
        address[] internal stakeholders;
        mapping(address => stake_amount)internal stakes;
        //mapping(address => uint) internal stakes;
        mapping(address => uint) internal rewards;

        constructor(uint total){
            owner = msg.sender;
            totalSupply = total;
            balances[msg.sender] = totalSupply;
        }

        
        function balanceof(address holder) public view returns(uint) {
            return balances[holder];
        }

        function holderBalanceof() public view returns(uint) {
            return balances[msg.sender];
        }

        function Transfer(address to, uint tokens) public returns (bool) {
            require(tokens <= balances[msg.sender], "Low Balance");
            balances[msg.sender] = balances[msg.sender] - tokens;
            balances[to] = balances[to] + tokens;
            emit TransferE (msg.sender, to, tokens); 
            return true;
        }

        function Approve(address Token_holder, uint NTokens) public returns (bool){
            allowed[msg.sender][Token_holder] = NTokens;
            emit Approval(msg.sender, Token_holder, NTokens);
            return true;
        }

        function transferFrom(address holder, address buyer, uint numTokens) public returns (bool) {
            require(numTokens <= balances[holder]);
            require(numTokens <= allowed[holder][msg.sender]);
            balances[holder] -= numTokens;
            allowed[holder][msg.sender] -= numTokens;
            balances[buyer] += numTokens;
            emit TransferE(holder, buyer, numTokens);
            return true;
        }

        function checkStakeholder(address Stkhldr_address) public view returns(bool, uint) {
            for (uint s = 0; s < stakeholders.length; s += 1){
            if (Stkhldr_address == stakeholders[s]) return (true, s);
        }
            return (false, 0);
        }

        function addStakeholder(address _stakeholder, uint Stake_amount) public {
        require(Stake_amount > 0, "Stake amount cannot be zero");
        require(balances[msg.sender] >= Stake_amount, "Low Balance" );

        (bool _isStakeholder, ) = checkStakeholder(_stakeholder);
        if(!_isStakeholder) stakeholders.push(_stakeholder);
        }

        function removeStakeholder(address Sholder) public {
        (bool _isStakeholder, uint s) = checkStakeholder(Sholder);
        if(_isStakeholder){
        stakeholders[s] = stakeholders[stakeholders.length - 1];
        stakeholders.pop();
        }

        }

        function holderReward(address _stakehldr) public view returns(uint){
        require(owner == msg.sender);
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

        
        function totalRewards() public view returns(uint){
        uint _totalRewards = 0;
        for (uint s = 0; s < stakeholders.length; s += 1){
        _totalRewards = adder(_totalRewards,rewards[stakeholders[s]]);
        }
        return _totalRewards;
        }

        function startStake() public returns(uint){
            require(owner == msg.sender);
            staking_time = block.timestamp;
            return staking_time;

        }

        function createStake(uint _stake) public {
        
            if(stakes[msg.sender].amount == 0) addStakeholder(msg.sender, _stake);
            
            stakes[msg.sender].amount = adder(stakes[msg.sender].amount,_stake);
                stakes[msg.sender].Timestamp = block.timestamp;
        }

        function removeStake(uint stk) public{
            stakes[msg.sender].amount = sub(stakes[msg.sender].amount,stk);
            if(stakes[msg.sender].amount == 0) removeStakeholder(msg.sender);
        }

        function mulDiv(uint _percent, uint _amount, uint z) internal pure returns(uint){
            return _percent * _amount/z;
        }
    
        function calculateReward(address holder) public view returns(uint ){
        require(msg.sender == owner );
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
        balances[msg.sender] += reward;
        rewards[msg.sender] = 0;
        }
    }
