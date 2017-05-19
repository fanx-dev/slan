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
class Context
{
  ** power of sql
  private const static SqlExecutor executor := SqlExecutor()

  **
  ** Get the connection to this database for the current thread.
  **
  SqlConn? conn

  internal ConnPool? connPool

  ** constructor
  new make(SqlConn conn)
  {
    this.conn = conn
  }

  Void close() {
    if (conn == null) return

    if (connPool != null) {
       connPool.close(conn)
    } else {
      conn.close
    }
    conn = null
  }

//////////////////////////////////////////////////////////////////////////
// Execute write
//////////////////////////////////////////////////////////////////////////

  ** insert this obj to database
  virtual Void insert(Record obj)
  {
    executor.insert(obj.schema, this.conn, obj)
  }

  ** update by id
  virtual Void updateById(Record obj)
  {
    executor.updateById(obj.schema, this.conn, obj)
  }

  virtual Void updateByCondition(Record obj, Str condition) {
    executor.updateByCondition(obj.schema, this.conn, obj, condition)
  }

  virtual Void updateByExample(Record obj, Record where) {
    executor.updateByExample(obj.schema, this.conn, obj, where)
  }

  ** delete by example
  virtual Void deleteByExample(Record obj)
  {
    executor.delete(obj.schema, this.conn, obj)
  }

  ** delete by id
  virtual Void deleteById(TableDef table, Obj id)
  {
    executor.removeById(table, this.conn, id)
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
  Obj[] select(TableDef table, Str where, Int offset := 0, Int limit := 50)
  {
    executor.selectWhere(table, this.conn, where, offset, limit)
  }

//////////////////////////////////////////////////////////////////////////
// By ID
//////////////////////////////////////////////////////////////////////////

  virtual Obj? findById(TableDef table, Obj id)
  {
    return executor.findById(table, this.conn, id)
  }

//////////////////////////////////////////////////////////////////////////
// Extend method
//////////////////////////////////////////////////////////////////////////

  ** count by example
  virtual Int count(Record obj)
  {
    return executor.count(obj.schema, this.conn, obj)
  }

  ** exist by example, this operate noCache
  Bool exist(Record obj)
  {
    n := executor.count(obj.schema, this.conn, obj)
    return n > 0
  }

  ** update or insert
  Void save(Record obj)
  {
    if (existById(obj))
    {
      updateById(obj)
    }
    else
    {
      insert(obj)
    }
  }

  private Bool existById(Record obj)
  {
    id := obj.getId
    if (id == null) return false
    if (findById(obj.schema, id) != null) {
      return true
    }
    return false
  }

//////////////////////////////////////////////////////////////////////////
// Table operate
//////////////////////////////////////////////////////////////////////////

  Void createTable(TableDef table)
  {
    executor.createTable(table, this.conn)
  }

  Void dropTable(TableDef table)
  {
    executor.dropTable(table, this.conn)
  }

  Bool tableExists(TableDef table)
  {
    return this.conn.meta.tableExists(table.name)
  }

  ** check the object table is fit to database table
  Bool checkTable(TableDef table)
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