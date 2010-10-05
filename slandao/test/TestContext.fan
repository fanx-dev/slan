//
// Copyright (c) 2010 Yang Jiandong
// Licensed under Eclipse Public License version 1.0
//
// History:
//   yangjiandong 2010-9-22 - Initial Contribution
//

using sql
**
**
**
internal const class TestContext
{
  const static Context noCacheContext
  static{
    pod := Pod.find("sql");
    db:= SqlService(
      pod.config("test.connection"),
      pod.config("test.username"),
      pod.config("test.password"),
      Type.find(pod.config("test.dialect")).make)
    tables:=Context.mappingTables([:],TestContext#.pod)
    noCacheContext=Context(db,tables)
  }
  
  const static CacheableContext c
  static{
    pod := Pod.find("sql");
    db:= SqlService(
      pod.config("test.connection"),
      pod.config("test.username"),
      pod.config("test.password"),
      Type.find(pod.config("test.dialect")).make)
    tables:=CacheableContext.mappingTables([:],TestContext#.pod)
    c=CacheableContext(db,tables)
  }
}
