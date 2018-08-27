pragma solidity^0.4.20;

import './kcc.sol';
import './mvc.sol';


contract crowdFunding {

    kccToken kcc;//kcc合约对象
    mvcCrowd mvc;//mvc合约对象
    uint kccUnit;//投票时最小的kcc单元
    uint mvcUnit;//一次最小的认购mvc数量
    address owner;
    //构造函数
    function crowdFunding(uint _kccUnit, uint _mvcUnit) public {
        kcc = new kccToken(21000000, msg.sender);
        mvc = new mvcCrowd(10000, "goAway", msg.sender);
        kccUnit = _kccUnit;
        mvcUnit = _mvcUnit;
        owner = msg.sender;
    }
    
    modifier onlyOwner() {
        require( msg.sender == owner );
        _;
    }
    //用于合约更新使用
    function setKccAddr(address kccaddr, address mvcAddr) onlyOwner  public {
        kcc = kccToken(kccaddr);
        mvc = mvcCrowd(mvcAddr);
    }
    //获得kcc与mvc的合约地址
    function getAddr() public view returns (address kccaddr,address mvcaddr) {
        kccaddr = kcc.getAddr();
        mvcaddr = mvc.getAddr();
        return ;
    }
    
    
}