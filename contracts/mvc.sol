pragma solidity^0.4.20;
pragma experimental ABIEncoderV2;


contract mvcCrowd {
    string public desc ;

    bool isFinished = false;//众筹是否结束

    address public owner;

    uint public totalCrowd = 0;//当前已经众筹数量
    uint public totalSupply = 0;//总量



    struct CrowdFundingInfo {
        address addr;
        uint    amount;
        uint    crowdTime;
    }
    uint userCount = 0;
    
    CrowdFundingInfo[1000] info; // 所有用户的众筹信息
    
    
    mapping(address=>uint) userID;//通过地址获得下标 
    event AirDrop(address _to, uint _val, uint _id);
    function mvcCrowd(uint _totalSupply, string _desc, address _owner) public {
        totalSupply = _totalSupply;
        owner = _owner;
        desc = _desc;
        
        userID[owner] = userCount++;
        info[0].addr = owner;
        info[0].amount = totalSupply * 10 / 100;
        info[0].crowdTime = now;
        totalCrowd = info[0].amount;
    }
    //空投
    function airDrop(address _to, uint _value) public returns ( bool) {
        assert( !isFinished );
        assert( msg.sender == owner );
        if( totalCrowd + _value  > 0 &&
            totalCrowd +_value <= totalSupply &&
            address(0) != _to
        ) 
        {
            uint id;
            if( userID[_to] > 0 &&  userID[_to] < userCount){
                //update 
                id = userID[_to];
                info[id].amount += _value;
                info[id].crowdTime = now;
            }
            else {
                // insert 
                id = userCount ++;
                userID[_to] = id;
                info[id].amount += _value;
                info[id].addr = _to;
                info[id].crowdTime = now;
            }
            totalCrowd += _value; 
            if( totalCrowd  == totalSupply ) {
                isFinished = true;
            }
            require( userCount <= 1000 );
            emit AirDrop(_to, _value, id);
            return true;
        }
        
        return false;
    }
    event CrowInfo(address _owner, uint _value, uint _id);
    //获得众筹信息
    function crowInfo(address _owner) constant returns (uint amount, uint crowdTime) {
        uint id = userID[_owner];
        addr = info[id].addr;
        amount = info[id].amount;
        crowdTime = info[id].crowdTime;
        emit CrowInfo(_owner, amount, id);
        return (amount, crowdTime);
    }
    //售票自动分账
    function ticketBooking() payable public {
        require( msg.value > 0);
        uint count = info.length;
        uint i = 0;
        for(i = 0; i < info.length ; i ++) {
            info[i].addr.transfer( msg.value * info[i].amount / totalSupply );
        }
    }
    
    function getBalance() public returns (uint) {
        return address(this).balance;
    }
    //返回合约地址
    function getAddr() public view returns (address) {
        return address(this);
    }
    
}