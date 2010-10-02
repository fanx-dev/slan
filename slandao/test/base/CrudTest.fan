//
// Copyright (c) 2010 Yang Jiandong
// Licensed under Eclipse Public License version 1.0
//
// History:
//   yangjiandong 2010-9-22 - Initial Contribution
//
using sql
**
** CRUD test
** 
internal class CrudTest:TestBase
{
  Void test(){
    execute|->|{
      insert
      select
      update
      delete
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
    
    stu2:=Student{
      name="yqq"
      age=24
      married=true
      weight=55f
      dt=DateTime.now
    }.insert
    verifyEq(stu2.sid,2)
  }
  
  Void select(){
    n:=Student{weight=55f}.select.size
    verifyEq(n,2)
    
    Student stu:=Student{sid=1}.select.first
    verifyEq(stu.name,"yjd")
    
    Student stu2:=c.findById(Student#,2)
    verifyEq(stu2.name,"yqq")
    
    Student[] stus:=c.selectWhere(Student#,"age>23")
    verifyEq(stus.size,1)
  }
  
  Void update(){
    Student stu:=Student{sid=1}.select.first
    stu.married=true
    stu.update
    
    Student stu2:=Student{sid=1}.select.first
    verifyEq(stu2.married,true)
  }
  
  Void delete(){
    Student stu:=Student{sid=1}.select.first
    stu.delete
    
    exist:=Student{sid=1}.exist
    verifyEq(exist,false)
  }
}
