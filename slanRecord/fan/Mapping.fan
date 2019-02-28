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
  private Str:TableDef tables := [:]

  new make(SqlConn conn, |Str->Bool|? tableFilter := null)
  {
    TableDef[] list := getDbSchema(conn, tableFilter)
    list.each
    {
      tables[it.name] = it
    }
  }

  virtual TableDef get(Str name)
  {
    tables.get(name)
  }

  Void each(|TableDef| f)
  {
    tables.each(f)
  }

  **
  ** try create the table,if noMatchDatabase throw a MappingErr
  **
  Void tryCreateAllTable(Context context)
  {
    this.tables.each |TableDef t|
    {
      if (context.tableExistsT(t))
      {
        if (!context.checkTableT(t))
        {
          throw Err("table $t.name not match the database")
        }
      }
      else
      {
        context.createTableT(t)
      }
    }
  }

  ** drop all table with in appliction
  Void dropAllTable(Context context)
  {
    this.tables.each |TableDef t|
    {
      if(context.tableExistsT(t))
      {
        context.dropTableT(t)
      }
    }
  }

//////////////////////////////////////////////////////////////////////////
// Tools
//////////////////////////////////////////////////////////////////////////

  static TableDef[] getDbSchema(SqlConn conn, |Str->Bool|? tableFilter := null)
  {
    tables := TableDef[,]
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

