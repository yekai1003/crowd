
pragma solidity^0.4.20;

import './erc20.sol';

contract kccToken is ERC20 {
    string public name = "kccb";
    //token的符号
    string public symbol = "kcc";
    //基金会地址
    address public fundation;
    //总空投数量
    uint public totalAirDrop;
    //总发行量
    uint private _totalSupply  ;
    //账户余额
    mapping(address=>uint) _balance;
    //授权余额
    mapping(address=>mapping(address=>uint)) _allowance;
     
    function kccToken(uint totalSupply, address _owner) public {
        _totalSupply = totalSupply;
        fundation = _owner;
        _balance[fundation] = totalSupply * 20 / 100;
        totalAirDrop = 0;
    }
    //空投
    function airDrop(address _to, uint _value) public {
        assert( msg.sender == fundation );
        if( totalAirDrop + _value + _balance[fundation] > 0 &&
            totalAirDrop +_value + _balance[fundation] <= _totalSupply &&
            address(0) != _to
        ) {
            _balance[_to] += _value;
        }
    }
    //查询总发行量
    function totalSupply() constant returns (uint totalSupply) {
        totalSupply = _totalSupply;
        return;
    }
    //查询余额
    function balanceOf(address _owner) constant returns (uint balance) {
        return _balance[_owner];
    }
    //转账处理
    function transfer(address _to, uint _value) returns (bool success) {
        // 余额充足+不难溢出 
        //assert( _balance[msg.sender] >= _value );
        if( _balance[msg.sender] >= _value &&
            address(0) != _to  &&
            _balance[_to] + _value > 0
        ) {
            // 一个增加，一个减少 
            _balance[msg.sender] -= _value;
            _balance[_to]  += _value;// if _to.val chao ji da > uint256
            emit Transfer(msg.sender, _to, _value);
            return true;
        }
        else {
            return false;
        }
        
        
    }
    //授权使用的转账
    function transferFrom(address _from, address _to, uint _value) returns (bool success) {
        if( address(0) != _to &&
            _balance[_to] + _value > 0 &&
            _allowance[_from][_to] >= _value &&
            _balance[_from] >= _value
        ) {
            _allowance[_from][_to] -= _value;
            _balance[_to] += _value;
            _balance[_from] -= _value;
            // dui zhang对账 
            //require(_balance[_to] + _balance[_from] = _allowance[_from][_to]);
            return true;
        }
        else {
            return false;
        }
    }
    //授权处理
    function approve(address _spender, uint _value) returns (bool success) {
        if( _balance[msg.sender] >= _value &&
            address(0) != _spender 
        ) {
            // 余额必须充足
            _allowance[msg.sender][_spender] = _value; 
            emit Approval(msg.sender, _spender, _value);
            
        }
        else {
            return false;
        }
    }
    // 查询授权的余额
    function allowance(address _owner, address _spender) constant returns (uint remaining) {
        return _allowance[_owner][_spender];
    }
    //返回合约地址
    function getAddr() public view returns (address) {
        return address(this);
    }
    
}