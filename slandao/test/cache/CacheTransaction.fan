//
// Copyright (c) 2010 Yang Jiandong
// Licensed under Eclipse Public License version 1.0
//
// History:
//   yangjiandong 2010-10-1 - Initial Contribution
//


**
**
**
class CacheTransaction:TestBase
{
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
  
  ////////////////////////////////////////////////////////////////////////
  //testErrorTrans
  ////////////////////////////////////////////////////////////////////////
  
  Void testErrorTrans(){
    execute|->|{
      insert
      errorTransaction
    }
  }
  
  Void errorTransaction(){
    try{
      c.trans{
        Student{sid=1}.select.first->delete
        verifyFalse(Student{sid=1}.exist)
        throw Err("test transaction")
      }
    }catch{}
    verify(Student{sid=1}.exist)
  }
  
  ////////////////////////////////////////////////////////////////////////
  //testSuccessTrans
  ////////////////////////////////////////////////////////////////////////
  
  Void testSuccessTrans(){
    execute|->|{
      insert
      successTransaction
    }
  }
  
  Void successTransaction(){
    c.trans{
      Student{sid=1}.select.first->delete
      verifyFalse(Student{sid=1}.exist)
    }
    verifyFalse(Student{sid=1}.exist)
  }
}
