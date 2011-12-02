//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

using slanData
using isql

const class Mapping
{
  const Str:Schema tables
  private const Schema[] list

  new make(Schema[] list)
  {
    this.list = list
    tables := Str:Schema[:]
    list.each
    {
      tables[it.name] = it
    }
    this.tables = tables
  }

  virtual Schema getTableByType(Type type)
  {
    getTableByName(type.name)
  }

  virtual Schema getTableByObj(Obj obj)
  {
    Record r := obj
    return getTableByName(r.schema.name)
  }

  virtual Schema getTableByName(Str name)
  {
    tables[name]
  }

  Void each(|Schema, Int| f)
  {
    list.each(f)
  }

//////////////////////////////////////////////////////////////////////////
// Tools
//////////////////////////////////////////////////////////////////////////

  **
  ** find the persistence object, @Ignore facet will ignore the type
  **
  static Schema[] mappingTables(Pod pod)
  {
    tables := Schema[,]
    pod.types.each |Type t|
    {
      if (t.hasFacet(Persistent#))
      {
        if (!t.hasFacet(Serializable#))
        {
          throw MappingErr("entity $t.name must be @Serializable")
        }
        table := SqlUtil.mappingFromType(t)
        tables.add(table)
      }
    }
    return tables
  }

  static Schema[] rMappingTables(SqlConn conn, |Str->Bool|? tableFilter := null)
  {
    tables := Schema[,]
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

**************************************************************************
**
**************************************************************************

const class OMapping : Mapping
{
  const [Type:Schema]? tTables

  new make(OSchema[] list) : super(list)
  {
    tables := Type:Schema[:]
    list.each
    {
      tables[it.type] = it
    }
    this.tTables = tables
  }

  override Schema getTableByType(Type type)
  {
    tTables[type]
  }

  override Schema getTableByObj(Obj obj)
  {
    getTableByType(obj.typeof)
  }
}