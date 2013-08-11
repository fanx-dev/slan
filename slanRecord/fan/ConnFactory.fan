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