//
// Copyright (c) 2010 Yang Jiandong
// Licensed under Eclipse Public License version 1.0
//
// History:
//   yangjiandong 2010-10-23 - Initial Contribution
//


**
**
**
class QueryTest:NewTestBase
{
  Void testSelectAll(){
    n:=Student{}.list.size
    verifyEq(n,4)
  }
  
  Void testWhereAll(){
    Student[] stus:=c.select(Student#,"")
    verifyEq(stus.size,4)
  }
  
  Void testSelectOrderby(){
    Student s:=Student{}.list("order by StudentAge desc").first
    verifyEq(s.name,"yjd4")
    
    Student s2:=c.select(Student#,"order by StudentAge desc").first
    verifyEq(s2.name,"yjd4")
  }
}
