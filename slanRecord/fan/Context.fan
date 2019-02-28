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

  private Type:TableDef typeToTableMap := [:]

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

  TableDef toTable(Type t) {
    typeToTableMap.getOrAdd(t) { ObjTableDef(t) }
  }

  TableDef getTable(Obj obj) {
    if (obj is Record) {
      return ((Record)obj).schema
    }
    return toTable(obj.typeof)
  }

//////////////////////////////////////////////////////////////////////////
// Execute write
//////////////////////////////////////////////////////////////////////////

  ** insert this obj to database
  virtual Void insert(Obj obj)
  {
    executor.insert(getTable(obj), this.conn, obj)
  }

  ** update by id
  virtual Void updateById(Obj obj)
  {
    executor.updateById(getTable(obj), this.conn, obj)
  }

  virtual Void updateByCondition(Obj obj, Str condition) {
    executor.updateByCondition(getTable(obj), this.conn, obj, condition)
  }

  virtual Void updateByExample(Obj obj, Obj where) {
    executor.updateByExample(getTable(obj), this.conn, obj, where)
  }

  ** delete by example
  virtual Void deleteByExample(Obj obj)
  {
    executor.delete(getTable(obj), this.conn, obj)
  }

  ** delete by id
  virtual Void deleteById(Type table, Obj id)
  {
    executor.removeById(toTable(table), this.conn, id)
  }
  virtual Void deleteByIdT(TableDef table, Obj id)
  {
    executor.removeById(table, this.conn, id)
  }

//////////////////////////////////////////////////////////////////////////
// select
//////////////////////////////////////////////////////////////////////////

  ** select by example
  Obj[] list(Obj obj, Str orderby := "", Int offset := 0, Int limit := 50)
  {
    return executor.select(getTable(obj), this.conn, obj, orderby, offset, limit)
  }

  ** select by example and get the first one
  Obj? one(Obj obj, Str orderby := "", Int offset := 0)
  {
    return executor.selectOne(getTable(obj), this.conn, obj, orderby, offset)
  }

//////////////////////////////////////////////////////////////////////////
// Select where
//////////////////////////////////////////////////////////////////////////

  ** query by condition
  Obj[] select(Type type, Str where, Int offset := 0, Int limit := 50)
  {
    executor.selectWhere(toTable(type), this.conn, where, offset, limit)
  }
  Obj[] selectT(TableDef table, Str where, Int offset := 0, Int limit := 50)
  {
    executor.selectWhere(table, this.conn, where, offset, limit)
  }

//////////////////////////////////////////////////////////////////////////
// By ID
//////////////////////////////////////////////////////////////////////////

  virtual Obj? findById(Type type, Obj id)
  {
    return executor.findById(toTable(type), this.conn, id)
  }
  virtual Obj? findByIdT(TableDef table, Obj id)
  {
    return executor.findById(table, this.conn, id)
  }

//////////////////////////////////////////////////////////////////////////
// Extend method
//////////////////////////////////////////////////////////////////////////

  ** count by example
  virtual Int count(Obj obj)
  {
    return executor.count(getTable(obj), this.conn, obj)
  }

  ** exist by example, this operate noCache
  Bool exist(Obj obj)
  {
    n := executor.count(getTable(obj), this.conn, obj)
    return n > 0
  }

  ** update or insert
  Void save(Obj obj)
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

  private Bool existById(Obj obj)
  {
    Obj? id
    if (obj is Record) {
      id = ((Record)obj).getId
    }
    else {
      table := getTable(obj)
      idF := table.id
      id = idF.get(obj)
    }

    if (id == null) return false
    if (findById(obj, id) != null) {
      return true
    }
    return false
  }

//////////////////////////////////////////////////////////////////////////
// Table operate
//////////////////////////////////////////////////////////////////////////

  Void createTable(Type table)
  {
    executor.createTable(toTable(table), this.conn)
  }

  Void dropTable(Type table)
  {
    executor.dropTable(toTable(table), this.conn)
  }

  Bool tableExists(Type table)
  {
    return this.conn.meta.tableExists(toTable(table).name)
  }

  ** check the object table is fit to database table
  Bool checkTable(Type table)
  {
    t := toTable(table)
    trow := this.conn.meta.tableMeta(t.name)
    return SqlUtil.checkMatchDb(t, trow)
  }


  Void createTableT(TableDef table)
  {
    executor.createTable(table, this.conn)
  }

  Void dropTableT(TableDef table)
  {
    executor.dropTable(table, this.conn)
  }

  Bool tableExistsT(TableDef table)
  {
    return this.conn.meta.tableExists(table.name)
  }

  ** check the object table is fit to database table
  Bool checkTableT(TableDef table)
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