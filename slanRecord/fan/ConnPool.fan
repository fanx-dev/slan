//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

using concurrent
using isql
using [java]java.lang::Class

**
** connection pool
**
const class ConnPool
{
  **
  ** The username used to connect to this database.
  **
  const Str? username

  **
  ** The password used to connect to this database.
  **
  const Str? password

  **
  ** The database specific string used to connect to the database.
  **
  const Str connectionStr

  ** Standard log for the sql service
  static const Log log := ConnPool#.pod.log

  ** actor
  private const Actor actor := Actor(ActorPool()) |Obj?[] arg->Obj?| { return receive(arg) }

  ** id for locals var
  private const Str listId := ConnPool#.qname + ".listId"

  ** receive msg
  private Obj? receive(Obj?[] arg)
  {
    Str op := arg[0]
    switch (op)
    {
      case "pop":
       return pop
      case "insert":
        insert(arg[1])
      case "clearAll":
        clearAll()
      default:
        throw UnsupportedErr()
    }
    return null;
  }

  new make(Str connStr, Str? username, Str? password){
    this.connectionStr = connStr
    this.username = username
    this.password = password
  }

  new makeConfig(Pod pod, Str configPrefix := "")
  {
    Class.forName(pod.config("${configPrefix}.driver", "org.h2.Driver"))
    this.connectionStr = pod.config("${configPrefix}.uri", "jdbc:h2:~/test")
    this.username = pod.config("${configPrefix}.username")
    this.password = pod.config("${configPrefix}.password")
    echo("$connectionStr")
  }

//////////////////////////////////////////////////////////////////////////
// public methods
//////////////////////////////////////////////////////////////////////////

  **
  ** pop from pool or open
  **
  SqlConn open(){
    Unsafe? obj := actor.send(["pop"].toImmutable).get
    if (obj != null)
    {
      SqlConn conn :=  obj.val
      //conn.increment
      return conn
    }
    else
    {
      if (log.isDebug) log.debug("open a new connection")
      return SqlConn.open(connectionStr, username, password)
    }
  }

  Context openContext() { Context(open) { connPool = this } }

  **
  ** not actually close ,just push into pool
  **
  Void close(SqlConn conn)
  {
    if (conn.isClosed) return

    if (conn.autoCommit == false)
    {
      conn.rollback
      conn.autoCommit = true
    }
    //if (conn.getCount != 0)
    //{
    //  throw SqlErr("connection can't be closed.")
    //}
    actor.send(["insert", Unsafe(conn)].toImmutable)
  }

  **
  ** close all connection and clear pool
  **
  Void clear()
  {
    actor.send(["clearAll"].toImmutable)
  }

//////////////////////////////////////////////////////////////////////////
// acotr methods
//////////////////////////////////////////////////////////////////////////

  private Unsafe[] list()
  {
     Actor.locals.getOrAdd(listId)
     {
       Unsafe[,]
     }
  }

  private Obj? pop()
  {
    if (!list.isEmpty)
    {
      Unsafe obj := list.pop
      SqlConn conn := obj.val
      //isValid vs isClosed
      if (!conn.isClosed) return obj
    }
    return null
  }

  private Void insert(Obj obj)
  {
    list.insert(0, obj)
  }

  private Void clearAll()
  {
    list.each
    {
      SqlConn conn := it.val
      conn.close
    }
    list.clear
  }
}

