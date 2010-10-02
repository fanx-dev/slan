//
// Copyright (c) 2010 Yang Jiandong
// Licensed under Eclipse Public License version 1.0
//
// History:
//   yangjiandong 2010-9-30 - Initial Contribution
//


**
**
**
internal class TransactionTest:TestBase
{
  Void test(){
    execute|->|{
      insert
      transaction
    }
  }
  
  Void insert(){
    stu:=Student{
      name="yjd"
      age=23
      married=false
      weight=55f
      dt=DateTime.now
    }.insert
    verifyEq(stu.sid,1)
  }
  
  Void transaction(){
    try{
      c.trans{
        Student{sid=1}.select.first->delete
        verifyFalse(Student{sid=1}.exist)
        throw Err("test transaction")
      }
    }catch{}
    verify(Student{sid=1}.exist)
  }
}
