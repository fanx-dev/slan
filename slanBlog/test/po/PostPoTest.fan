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
class PostPoTest:Test
{
  Void test(){
    MyContext.c.use{
      MyContext.newTable(Post#)
      p:=Post{author="1";dt=DateTime.now;text="hello";point=0}.insert
      
      list:=Post{author="1"}.select
      
      verifyEq(list.size,1)
    }
  }
}
