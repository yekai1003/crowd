//调用js
$(function(){
   //弹窗
   $('#myModal').modal();
   var acctAddr;
   //构造web3对象
   var web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
   web3.eth.getAccounts(function(e,r){
      console.log(e,r);
   });
   //构造crowd合约对象
   var crowdContractAddr = "0xff4a070519f86d9976ad003b0f16411106321fa1";
   var ownerAddr = "0x71e3ece8371b6da0e6e6d69b03397767558e617f";
   var crowdObj = new web3.eth.Contract(crowdAbi, crowdContractAddr);
   var mvcContractAddr;
   var mvcObj;

   //登陆按钮被点击
   $(".Login").on("click",function(){
      acctAddr = $("#addressId").val();
      console.log("get acct:",acctAddr);
      $(".close_win").click();
   });

   $(".Buy").on("click",function(){
      //活动mvc对象，调用mvc-ticketBooking
      crowdObj.methods.getAddr().call(function(e,r){
         if(!e) {
            mvcContractAddr = r.mvcaddr;
            mvcObj = new web3.eth.Contract(mvcAbi, mvcContractAddr);
            mvcObj.methods.ticketBooking().send(
               {
                  from : acctAddr,
                  value : 20000000000000000,
                  gas : 300000
               },function(e,r){
                  if(!e) {
                     alert("购票成功");
                  }
                  else {
                     alert("购票失败");
                     console.log("购票失败:",e);
                  }
            });
         }
      });

   });


});