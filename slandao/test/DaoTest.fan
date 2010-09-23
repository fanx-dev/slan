//
// Copyright (c) 2010 Yang Jiandong
// Licensed under Eclipse Public License version 1.0
//
// History:
//   yangjiandong 2010-9-22 - Initial Contribution
//
using sql

class DaoTest:Test
{
  once Context c(){
    TestContext.c
  }
  
  Void test(){
    log:=Pod.of(this).log
    level:=log.level
    try
    {
      log.level=LogLevel.debug
      c.db.open
      newTable(Student#)
      insert
      select
      update
      delete
      transaction
    }
    catch (Err e)
    {
      throw e
    }
    finally
    {
      c.db.close
      verify(c.db.isClosed)
      log.level=level
    }
  }
  
  Void newTable(Type type){
    if(c.tableExists(type)){
      c.dropTable(type)
    }
    c.createTable(type)
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
  
  Void transaction(){
    c.trans{
      Student{sid=2}.select.first->delete
      verifyFalse(Student{sid=2}.exist)
      throw Err("test transaction")
    }
    verify(Student{sid=2}.exist)
  }
}
