//js 调用
$(function(){
   //弹窗
   $('#myModal').modal();
   //构造web3对象
   var web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
   web3.eth.getAccounts(function(e,r){
      console.log(e,r);
   });
   //构造crowd合约对象
   var crowdContractAddr = "0xff4a070519f86d9976ad003b0f16411106321fa1";
   var ownerAddr = "0x71e3ece8371b6da0e6e6d69b03397767558e617f";
   var crowdObj = new web3.eth.Contract(crowdAbi, crowdContractAddr);
   var acctAddr;
   var kccContractAddr;
   var mvcContractAddr;
   var kccObj;
   console.log(crowdObj);

   //登陆按钮被点击
   $(".Login").on("click",function(){
      acctAddr = $("#addressId").val();
      console.log("get acct:",acctAddr);
      $(".close_win").click();
   });
   //充值kcc
   $(".Recharge").on("click",function(){
      //1. 获得kcc合约地址 
      crowdObj.methods.getAddr().call(function(e,r){
         if(!e) {
            kccContractAddr = r.kccaddr;
            mvcContractAddr = r.mvcaddr;
            console.log("get addr:",kccContractAddr,mvcContractAddr);
            //2. 获得kcc合约对象
            kccObj = new web3.eth.Contract(kccAbi, kccContractAddr);
            //3. 调用kcc-》airDrop方法
            kccObj.methods.airDrop(acctAddr, 1000).send(
               {
               from : ownerAddr,//owner
               gas : 300000
            },function(e,r){
               if(!e) {
                  alert("充值成功");
               }
               else {
                  alert("失败");
                  console.log("充值失败：",e);
               }
            });
         }
      });
      
      
   });

   //投票处理- 此时可以认为合约地址都已经拿到,kcc合约对象，mvc合约地址
   $(".Vote").on("click",function(){
      //1. 构造mvc对象
      mvcObj = new web3.eth.Contract(mvcAbi, mvcContractAddr);
      //2. 调用kcc转账给owner,至少1000 kcc
      kccObj.methods.transfer(ownerAddr, 1000).send(
         {
            from : acctAddr,
            gas  : 300000
         },function(e,r){
            if(!e) {
               console.log("transfer ok:");
               //3. 调用mvc的空投给acctAddr
               mvcObj.methods.airDrop(acctAddr,1000).send(
                  {
                     from : ownerAddr,
                     gas  : 300000
                  },function(e,r){
                     if(!e) {
                        alert("投票成功");
                     }
                     else {
                        alert("投票失败");
                        console.log("失败:",e);
                     }
               });
            }
      });
      

   });

});