//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

using sql

**
**
**
internal mixin TestConnection
{
  const static CacheableContext c
  static
  {
    pod := Pod.find("sql")
    db := SqlServ(
      pod.config("test.uri"),
      pod.config("test.username"),
      pod.config("test.password"))

    tables := CacheableContext.mappingTables([:], TestConnection#.pod)
    c = CacheableContext(db, tables)
  }
}