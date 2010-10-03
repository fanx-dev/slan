//
// Copyright (c) 2010 Yang Jiandong
// Licensed under Eclipse Public License version 1.0
//
// History:
//   yangjiandong 2010-10-3 - Initial Contribution
//
using sql
using slandao
**
**
**
const class Connection
{
  const static Connection cur:=Connection()
  private new make(){}
  
  const CacheContext c:=get
  
  private CacheContext get(){
    pod := Pod.find("sql");
    db:= SqlService(
      pod.config("test.connection"),
      pod.config("test.username"),
      pod.config("test.password"),
      Type.find(pod.config("test.dialect")).make)
    tables:=CacheContext.createTables([:],MyContext#.pod)
    ct:=CacheContext(db,tables)
    
    //testConnect
    ct.use{}
    
    return ct
  }
  
  **only for test
  Void clearTables(){
    c.use{c.dropAllTable;c.tryCreateAllTable}
  }
}
