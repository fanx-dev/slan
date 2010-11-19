//
// Copyright (c) 2010 Yang Jiandong
// Licensed under Eclipse Public License version 1.0
//
// History:
//   yangjiandong 2010-10-7 - Initial Contribution
//
using sql

**
**
**
mixin TestConnection
{
  const static CacheableContext c
  static{
    pod := Pod.find("sql");
    db:= SqlService(
      pod.config("test.connection"),
      pod.config("test.username"),
      pod.config("test.password"),
      Type.find(pod.config("test.dialect")).make)
    tables:=CacheableContext.mappingTables([:],TestConnection#.pod)
    c=CacheableContext(db,tables)
  }
}
