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
internal class TestBase:Test
{
  virtual CacheableContext c:=TestContext.c
  
  Void execute(|->| f){
    log:=Pod.of(this).log
    level:=log.level
    try
    {
      log.level=LogLevel.debug
      c.db.open
      newTable(Student#)
      f()
    }
    catch (Err e)
    {
      throw e
    }
    finally
    {
      c.db.close
      log.level=level
    }
  }
  
  Void newTable(Type type){
    c.clearDatabase
    c.createTable(type)
    c.clearCache
  }
  
  Void testConnetcion(){
    execute|->|{echo("ok")}
  }
}
