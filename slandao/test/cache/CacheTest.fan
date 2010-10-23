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
internal class CacheTest:NewTestBase
{
  override Void setup(){
    c.refreshDatabase
    log.level=LogLevel.debug
  }
  
  Void test(){
    c.use{
      this.insert
      this.select
      this.selectWhere
      this.count
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
    stu:=Student{sid=1}.list.first
    stu2:=Student{sid=1}.list.first
    stu3:=Student{sid=1}.one
  }
  
  Void selectWhere(){
    stu:=c.select(Student#,"where StudentAge>20")
    stu2:=c.select(Student#,"where StudentAge>20")
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
    insert
    stu:=Student{sid=1}.one as Student
    stu.deleteByExample
    stu2:=Student{sid=1}.one
    verify(stu2==null)
  }
}
