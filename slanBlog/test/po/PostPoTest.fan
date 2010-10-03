//
// Copyright (c) 2010 Yang Jiandong
// Licensed under Eclipse Public License version 1.0
//
// History:
//   yangjiandong 2010-10-2 - Initial Contribution
//

**
**
**
class PostPoTest:Test,MyContext
{
  Void test(){
    Connection.cur.clearTables
    c.use{
      p:=PostPo{author="1";dt=DateTime.now;text="hello";point=0}.insert
      
      list:=PostPo{author="1"}.select
      
      verifyEq(list.size,1)
    }
  }
}
