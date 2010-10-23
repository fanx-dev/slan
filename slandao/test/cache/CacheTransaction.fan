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
internal class CacheTransaction:NewTestBase
{
  Void testErrorTransaction(){
    try{
      c.trans{
        Student{sid=1}.list.first->delete
        verifyFalse(Student{sid=1}.exist)
        throw Err("test transaction")
      }
    }catch{}
    verify(Student{sid=1}.exist)
  }
  
  Void testSuccessTransaction(){
    c.trans{
      Student{sid=1}.list.first->deleteByExample
      verifyFalse(Student{sid=1}.exist)
    }
    verifyFalse(Student{sid=1}.exist)
  }
}
