//
// Copyright (c) 2010 Yang Jiandong
// Licensed under Eclipse Public License version 1.0
//
// History:
//   yangjiandong 2010-10-7 - Initial Contribution
//


**
**
**
class LimitQueryTest : NewTestBase
{
  Void testLimit(){
    ps:=Student{}.list("",0,3)
    verifyEq(ps.size,3)
  }
  
  Void testLimitAndOffset(){
    ps:=Student{}.list("",2,10)
    verifyEq(ps.size,2)
  }
  
  Void testOffset(){
    Student? ps:=Student{}.one("",1)
    verifyEq(ps.name,"yjd2")
  }
}
