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
internal class CacheTest:TestBase
{
  Void test(){
    execute|->|{
      insert
      select
      selectWhere
      count
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
  
  ////////////////////////////////////////////////////////////////////////
  //query
  ////////////////////////////////////////////////////////////////////////
  
  Void select(){
    stu:=Student{sid=1}.select.first
    stu2:=Student{sid=1}.select.first
    stu3:=Student{sid=1}.one
  }
  
  Void selectWhere(){
    stu:=c.selectWhere(Student#,"StudentAge>20")
    stu2:=c.selectWhere(Student#,"StudentAge>20")
  }
  
  Void count(){
    n:=Student{sid=1}.count
    n2:=Student{sid=1}.count
    verifyEq(n,n2)
  }
  
  ////////////////////////////////////////////////////////////////////////
  //write
  ////////////////////////////////////////////////////////////////////////
  
  Void testDelete(){
    execute|->|{
      insert
      stu:=Student{sid=1}.one as Student
      stu.delete
      stu2:=Student{sid=1}.one
      verify(stu2==null)
    }
  }
}
