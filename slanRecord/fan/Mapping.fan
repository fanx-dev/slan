//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

using isql
using concurrent

class Mapping
{
  private Str:Table tables := [:]

  new make(SqlConn conn, |Str->Bool|? tableFilter := null)
  {
    Table[] list := getDbSchema(conn, tableFilter)
    list.each
    {
      tables[it.name] = it
    }
  }

  virtual Table get(Str name)
  {
    tables.get(name)
  }

  Void each(|Table| f)
  {
    tables.each(f)
  }

  **
  ** try create the table,if noMatchDatabase throw a MappingErr
  **
  Void tryCreateAllTable(Context context)
  {
    this.tables.each |Table t|
    {
      if (context.tableExists(t))
      {
        if (!context.checkTable(t))
        {
          throw MappingErr("table $t.name not match the database")
        }
      }
      else
      {
        context.createTable(t)
      }
    }
  }

  ** drop all table with in appliction
  Void dropAllTable(Context context)
  {
    this.tables.each |Table t|
    {
      if(context.tableExists(t))
      {
        context.dropTable(t)
      }
    }
  }

//////////////////////////////////////////////////////////////////////////
// Tools
//////////////////////////////////////////////////////////////////////////

  static Table[] getDbSchema(SqlConn conn, |Str->Bool|? tableFilter := null)
  {
    tables := Table[,]
    conn.meta.tables.each |Str t|
    {
      if (tableFilter == null || tableFilter(t))
      {
        cols := conn.meta.tableMeta(t)
        s := SqlUtil.colsToSchema(t, cols)
        tables.add(s)
      }
    }
    return tables
  }
}

