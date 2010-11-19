//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

using isql

**
**
**
mixin TestConnection
{
  const static CacheableContext c
  static
  {
    pod := Pod.find("isql")
    db := SqlService(
      pod.config("test.connection"),
      pod.config("test.username"),
      pod.config("test.password"),
      pod.config("test.driver"))
    
    tables := CacheableContext.mappingTables([:], TestConnection#.pod)
    c = CacheableContext(db, tables)
  }
}
