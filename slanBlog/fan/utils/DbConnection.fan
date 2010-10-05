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
const class DbConnection
{
  const static DbConnection cur:=DbConnection()
  private new make(){}
  
  const CacheableContext c:=get
  
  private CacheableContext get(){
    pod := Pod.find("sql");
    db:= SqlService(
      pod.config("test.connection"),
      pod.config("test.username"),
      pod.config("test.password"),
      Type.find(pod.config("test.dialect")).make)
    
    tables:=CacheableContext.mappingTables([:],DbConnection#.pod)
    ct:=CacheableContext(db,tables)
    
    ct.tryCreateAllTable
    return ct
  }
}
