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
  ** thread connection id
  static const Str id := Context#.qname + ".conn"

  ** mapping table model
  const Type:Table tables

  ** power of sql
  private const Executor executor := Executor()

  ** constructor
  new make(Type:Table tables)
  {
    this.tables = tables
  }

  ** get type's mapping table
  Table getTable(Type t)
  {
    return tables[t]
  }

  **
  ** Get the connection to this database for the current thread.
  **
  SqlConn conn()
  {
    SqlConn? c := Actor.locals[id]
    if (c == null) throw SqlErr("Database is not open.")
    if (c.isClosed) throw SqlErr("Database has been closed.")
    return c
  }

//////////////////////////////////////////////////////////////////////////
// Tools
//////////////////////////////////////////////////////////////////////////

  **
  ** find the persistence object,@Ignore facet will ignore the type
  **
  static Type:Table mappingTables(Type:Table tables, Pod pod,
                              SlanDialect dialect := MysqlDialect())
  {
    pod.types.each |Type t|
    {
      if (t.hasFacet(Persistent#))
      {
        if (!t.hasFacet(Serializable#))
        {
          throw MappingErr("entity $t.name must be @Serializable")
        }
        table := Table.mappingFromType(t, dialect)
        tables[t] = table
      }
    }
    return tables
  }

  **
  ** using connection finally will close
  **
  Void use(|This| f)
  {
    try
    {
      f(this)
    }
    catch (Err e)
    {
      throw e
    }
    finally
    {
      conn.close
    }
  }

//////////////////////////////////////////////////////////////////////////
// Execute write
//////////////////////////////////////////////////////////////////////////

  ** insert this obj to database
  virtual Void insert(Obj obj)
  {
    table := getTable(obj.typeof)
    this.executor.insert(table, this.conn, obj)
  }

  ** update by id
  virtual Void update(Obj obj)
  {
    table := getTable(obj.typeof)
    this.executor.update(table, this.conn, obj)
  }

  ** delete by example
  virtual Void deleteByExample(Obj obj)
  {
    table := getTable(obj.typeof)
    this.executor.delete(table, this.conn, obj)
  }

  ** delete by id
  virtual Void deleteById(Type type, Obj id)
  {
    table := getTable(type)
    this.executor.removeById(table, this.conn, id)
  }

//////////////////////////////////////////////////////////////////////////
// select
//////////////////////////////////////////////////////////////////////////

  ** select by example
  Obj[] list(Obj obj, Str orderby := "", Int offset := 0, Int limit := 50)
  {
    table := getTable(obj.typeof)
    return executor.select(table, this.conn, obj, orderby, offset, limit)
  }

  ** select by example and get the first one
  Obj? one(Obj obj, Str orderby := "", Int offset := 0)
  {
    table := getTable(obj.typeof)
    return executor.selectOne(table, this.conn, obj, orderby, offset)
  }

//////////////////////////////////////////////////////////////////////////
// Select where
//////////////////////////////////////////////////////////////////////////

  ** query by condition
  Obj[] select(Type type, Str condition, Int offset := 0, Int limit := 50)
  {
    table := getTable(type)
    return this.executor.selectWhere(table, this.conn, condition, offset, limit)
  }

//////////////////////////////////////////////////////////////////////////
// By ID
//////////////////////////////////////////////////////////////////////////

  virtual Obj? findById(Type type, Obj id){
    table := getTable(type)
    return this.executor.findById(table, this.conn, id)
  }

  ** get object id value by mapping table
  Obj? getId(Obj obj)
  {
    table := getTable(obj.typeof)
    return table.id.field.get(obj)
  }

//////////////////////////////////////////////////////////////////////////
// Extend method
//////////////////////////////////////////////////////////////////////////

  ** count by example
  virtual Int count(Obj obj)
  {
    table := getTable(obj.typeof)
    return this.executor.count(table, this.conn, obj)
  }

  ** exist by example,this operate noCache
  Bool exist(Obj obj)
  {
    table := getTable(obj.typeof)
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
    table := getTable(obj.typeof)
    id := table.id.field.get(obj)
    if (findById(obj.typeof, id) != null)
    {
      return true
    }
    return false
  }

//////////////////////////////////////////////////////////////////////////
// Table operate
//////////////////////////////////////////////////////////////////////////

  Void createTable(Type type)
  {
    table := getTable(type)
    this.executor.createTable(table, this.conn)
  }

  Void dropTable(Type type)
  {
    table := getTable(type)
    this.executor.dropTable(table, this.conn)
  }

  Bool tableExists(Type type)
  {
    table := getTable(type)
    return this.conn.meta.tableExists(table.name)
  }

  ** check the object table is fit to database table
  Bool checkTable(Table table)
  {
    trow := this.conn.meta.tableMeta(table.name)
    return table.checkMatchDb(trow)
  }

  **
  ** try create the table,if noMatchDatabase throw a MappingErr
  **
  Void tryCreateAllTable()
  {
    this.tables.vals.each |Table t|
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
    this.tables.vals.each |Table t|
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