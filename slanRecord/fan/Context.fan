//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

using isql
using concurrent

**
** session and manager
**
const class Context
{
  ** power of sql
  private const SqlExecutor executor := SqlExecutor()

  ** thread connection id
  const Str curId := Context#.qname + ".conn"

  ** constructor
  new make(SqlConn conn)
  {
    Actor.locals[curId] = conn
  }

  **
  ** Get the connection to this database for the current thread.
  **
  SqlConn conn()
  {
    SqlConn? c := Actor.locals[curId]
    if (c == null) throw SqlErr("Database is not open.")
    if (c.isClosed) throw SqlErr("Database has been closed.")
    return c
  }

//////////////////////////////////////////////////////////////////////////
// Execute write
//////////////////////////////////////////////////////////////////////////

  ** insert this obj to database
  virtual Void insert(Record obj)
  {
    this.executor.insert(obj.schema, this.conn, obj)
  }

  ** update by id
  virtual Void update(Record obj)
  {
    this.executor.update(obj.schema, this.conn, obj)
  }

  ** delete by example
  virtual Void deleteByExample(Record obj)
  {
    this.executor.delete(obj.schema, this.conn, obj)
  }

  ** delete by id
  virtual Void deleteById(Table table, Obj id)
  {
    this.executor.removeById(table, this.conn, id)
  }

//////////////////////////////////////////////////////////////////////////
// select
//////////////////////////////////////////////////////////////////////////

  ** select by example
  Obj[] list(Record obj, Str orderby := "", Int offset := 0, Int limit := 50)
  {
    return executor.select(obj.schema, this.conn, obj, orderby, offset, limit)
  }

  ** select by example and get the first one
  Obj? one(Record obj, Str orderby := "", Int offset := 0)
  {
    return executor.selectOne(obj.schema, this.conn, obj, orderby, offset)
  }

//////////////////////////////////////////////////////////////////////////
// Select where
//////////////////////////////////////////////////////////////////////////

  ** query by condition
  Obj[] select(Table table, Str condition, Int offset := 0, Int limit := 50)
  {
    this.executor.selectWhere(table, this.conn, condition, offset, limit)
  }

//////////////////////////////////////////////////////////////////////////
// By ID
//////////////////////////////////////////////////////////////////////////

  virtual Obj? findById(Table table, Obj id)
  {
    return this.executor.findById(table, this.conn, id)
  }

//////////////////////////////////////////////////////////////////////////
// Extend method
//////////////////////////////////////////////////////////////////////////

  ** count by example
  virtual Int count(Record obj)
  {
    return this.executor.count(obj.schema, this.conn, obj)
  }

  ** exist by example, this operate noCache
  Bool exist(Record obj)
  {
    n := this.executor.count(obj.schema, this.conn, obj)
    return n > 0
  }

  ** update or insert
  Void save(Record obj)
  {
    if (existById(obj))
    {
      update(obj)
    }
    else
    {
      insert(obj)
    }
  }

  private Bool existById(Record obj)
  {
    id := obj.getId
    if (findById(obj.schema, id) != null)
    {
      return true
    }
    return false
  }

//////////////////////////////////////////////////////////////////////////
// Table operate
//////////////////////////////////////////////////////////////////////////

  Void createTable(Table table)
  {
    this.executor.createTable(table, this.conn)
  }

  Void dropTable(Table table)
  {
    this.executor.dropTable(table, this.conn)
  }

  Bool tableExists(Table table)
  {
    return this.conn.meta.tableExists(table.name)
  }

  ** check the object table is fit to database table
  Bool checkTable(Table table)
  {
    trow := this.conn.meta.tableMeta(table.name)
    return SqlUtil.checkMatchDb(table, trow)
  }

//////////////////////////////////////////////////////////////////////////
// Transaction
//////////////////////////////////////////////////////////////////////////

  ** transaction , if error will auto roolback
  virtual Void trans(|This| f)
  {
    oauto := this.conn.autoCommit
    try
    {
      this.conn.autoCommit = false

      f(this)
      this.conn.commit
    }
    catch (Err e)
    {
      this.conn.rollback
      throw e
    }
    finally
    {
      this.conn.autoCommit = oauto
    }
  }
}