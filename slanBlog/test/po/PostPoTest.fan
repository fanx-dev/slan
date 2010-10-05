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
class PostPoTest:MyTest
{
  Void test(){
    c.use{
      p:=Post{author="chunquedong";dt=DateTime.now;text="hello";point=0}.insert
      list:=Post{author="chunquedong"}.select
      
      verifyEq(list.size,1)
    }
  }
}
