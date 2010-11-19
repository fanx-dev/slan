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
internal class TransactionTest:NewTestBase
{
  Void testTransaction(){
    try{
      c.trans{
        Student{sid=1}.one->delete
        verifyFalse(Student{sid=1}.exist)
        throw Err("test transaction")
      }
    }catch{}
    verify(Student{sid=1}.exist)
  }
}
