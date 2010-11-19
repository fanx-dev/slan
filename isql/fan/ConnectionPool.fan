//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

using concurrent

**
** cache connection
**
const class ConnectionPool
{
  **
  ** The database driver for classLoader.
  **
  const Str driver

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
  static const Log log := Log.get("isql")

  ** actor
  private const Actor actor := Actor(ActorPool()) |Obj?[] arg->Obj?| { return receive(arg) }

  ** id for locals var
  private const Str listId := "isql::ConnectionPool.listId"

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

  new make(Str connStr, Str? username, Str? password, Str driver){
    this.connectionStr = connStr
    this.username = username
    this.password = password
    this.driver = driver
  }

//////////////////////////////////////////////////////////////////////////
// public methods
//////////////////////////////////////////////////////////////////////////

  **
  ** pop from pool or open
  **
  Connection open(){
    Unsafe? obj := actor.send(["pop"].toImmutable).get
    if (obj != null)
    {
      Connection conn :=  obj.val
      conn.increment
      return conn
    }
    else
    {
      if (log.isDebug) log.debug("open a new connection")
      return Connection.open(connectionStr, username, password, driver)
    }
  }

  **
  ** not actually close ,just push into pool
  **
  Void close(Connection conn)
  {
    if (conn.autoCommit == false)
    {
      conn.rollback
      conn.autoCommit = true
    }
    if (conn.getCount != 0)
    {
      throw SqlErr("connection can't be closed.")
    }
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
      Connection conn := obj.val
      if (conn.isValid) return obj
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
      Connection conn := it.val
      conn.close
    }
    list.clear
  }
}

