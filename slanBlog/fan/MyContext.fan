//
// Copyright (c) 2010 Yang Jiandong
// Licensed under Eclipse Public License version 1.0
//
// History:
//   yangjiandong 2010-10-2 - Initial Contribution
//

using slandao
using sql
**
**
**
mixin MyContext
{
  const static CacheContext c
  static{
    pod := Pod.find("sql");
    db:= SqlService(
      pod.config("test.connection"),
      pod.config("test.username"),
      pod.config("test.password"),
      Type.find(pod.config("test.dialect")).make)
    tables:=CacheContext.createTables([:],MyContext#.pod)
    c=CacheContext(db,tables)
    c.use|Context c->Obj?|{c.dropAllTable;c.tryCreateAllTable;return null}
  }
  
  static Void newTable(Type type){
    if(c.tableExists(type)){
      c.dropTable(type)
    }
    c.createTable(type)
    c.clearCache
  }
}
