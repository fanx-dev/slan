//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2011-11-13  Jed Young  Creation
//

using [java]java.lang::Class
using concurrent

**
** data connection factory
**
const class ConnFactory
{
  private const ConnectionPool pool
  private const Log log := Pod.of(this).log

  new make(Pod pod, Str configPrefix := "test")
  {
    Class.forName(pod.config("${configPrefix}.driver", "org.h2.Driver"))
    pool = ConnectionPool(
      pod.config("${configPrefix}.uri", "jdbc:h2:~/test"),
      pod.config("${configPrefix}.username"),
      pod.config("${configPrefix}.password"))
  }

  Context initFromPod(Pod pod)
  {
    tables := Mapping.mappingTables(pod)
    if (log.isDebug)
    {
      tables.each { log.debug(it.toStr) }
    }
    return CacheableContext(OMapping(tables))
  }

  Context initFromDb(|Str->Bool|? tableFilter := null)
  {
    conn := pool.open
    tables := Mapping.rMappingTables(conn, tableFilter)
    if (log.isDebug)
    {
      tables.each { log.debug(it.toStr) }
    }
    pool.close(conn)
    return CacheableContext(Mapping(tables))
  }

  Void open()
  {
    conn := pool.open
    Actor.locals[Context.id] = conn
  }

  Void close()
  {
    conn := Actor.locals[Context.id]
    if (conn != null) pool.close(conn)
    Actor.locals.remove(Context.id)
  }
}