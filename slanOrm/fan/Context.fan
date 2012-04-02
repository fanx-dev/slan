//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

using isql
using concurrent
using slanData

**
** session and manager
**
const class Context
{
  ** thread connection id
  static const Str id := Context#.qname + ".conn"

  ** mapping table model
  private const Mapping tables

  ** power of sql
  private const Executor executor

  const Str curId

  ** constructor
  new make(Str curId := id, Mapping tables := Mapping([,]), Dialect dialect := Dialect())
  {
    this.tables = tables
    this.curId = curId
    executor = Executor(dialect)
  }

  ** get type's mapping table
  Schema getTable(Obj obj)
  {
    if (obj is Type)
    {
      type := obj as Type
      return tables.getFromType(type)
    }
    else if (obj is Record)
    {
      Record r := obj
      return r.schema
    }
    else
    {
      return tables.getFromType(obj.typeof)
    }
  }

  Schema getTableFromDb(Str name)
  {
    tables.getFromDb(conn, name)
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
  virtual Void insert(Obj obj)
  {
    table := getTable(obj)
    this.executor.insert(table, this.conn, obj)
  }

  ** update by id
  virtual Void update(Obj obj)
  {
    table := getTable(obj)
    this.executor.update(table, this.conn, obj)
  }

  ** delete by example
  virtual Void deleteByExample(Obj obj)
  {
    table := getTable(obj)
    this.executor.delete(table, this.conn, obj)
  }

  ** delete by id
  virtual Void deleteById(Schema table, Obj id)
  {
    this.executor.removeById(table, this.conn, id)
  }

//////////////////////////////////////////////////////////////////////////
// select
//////////////////////////////////////////////////////////////////////////

  ** select by example
  Obj[] list(Obj obj, Str orderby := "", Int offset := 0, Int limit := 50)
  {
    table := getTable(obj)
    return executor.select(table, this.conn, obj, orderby, offset, limit)
  }

  ** select by example and get the first one
  Obj? one(Obj obj, Str orderby := "", Int offset := 0)
  {
    table := getTable(obj)
    return executor.selectOne(table, this.conn, obj, orderby, offset)
  }

//////////////////////////////////////////////////////////////////////////
// Select where
//////////////////////////////////////////////////////////////////////////

  ** query by condition
  Obj[] select(Schema table, Str condition, Int offset := 0, Int limit := 50)
  {
    this.executor.selectWhere(table, this.conn, condition, offset, limit)
  }

//////////////////////////////////////////////////////////////////////////
// By ID
//////////////////////////////////////////////////////////////////////////

  virtual Obj? findById(Schema table, Obj id)
  {
    return this.executor.findById(table, this.conn, id)
  }

  ** get object id value by mapping table
  Obj? getId(Obj obj)
  {
    table := getTable(obj)
    return table.id.get(obj)
  }

//////////////////////////////////////////////////////////////////////////
// Extend method
//////////////////////////////////////////////////////////////////////////

  ** count by example
  virtual Int count(Obj obj)
  {
    table := getTable(obj)
    return this.executor.count(table, this.conn, obj)
  }

  ** exist by example, this operate noCache
  Bool exist(Obj obj)
  {
    table := getTable(obj)
    n := this.executor.count(table, this.conn, obj)
    return n > 0
  }

  ** update or insert
  Void save(Obj obj)
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

  private Bool existById(Obj obj)
  {
    table := getTable(obj)
    id := table.id.get(obj)
    if (findById(table, id) != null)
    {
      return true
    }
    return false
  }

//////////////////////////////////////////////////////////////////////////
// Table operate
//////////////////////////////////////////////////////////////////////////

  Void createTable(Schema table)
  {
    this.executor.createTable(table, this.conn)
  }

  Void dropTable(Schema table)
  {
    this.executor.dropTable(table, this.conn)
  }

  Bool tableExists(Schema table)
  {
    return this.conn.meta.tableExists(table.name)
  }

  ** check the object table is fit to database table
  Bool checkTable(Schema table)
  {
    trow := this.conn.meta.tableMeta(table.name)
    return SqlUtil.checkMatchDb(table, trow)
  }

  **
  ** try create the table,if noMatchDatabase throw a MappingErr
  **
  Void tryCreateAllTable()
  {
    this.tables.each |Schema t|
    {
      if (this.conn.meta.tableExists(t.name))
      {
        if (!checkTable(t))
        {
          throw MappingErr("table $t.name not match the database")
        }
      }
      else
      {
        this.executor.createTable(t, this.conn)
      }
    }
  }

  ** drop all table with in appliction
  Void dropAllTable()
  {
    this.tables.each |Schema t|
    {
      if(this.conn.meta.tableExists(t.name))
      {
        this.executor.dropTable(t, this.conn)
      }
    }
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