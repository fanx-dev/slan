//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

using slanData
using isql
using slanActor::Cache as SlanCache

const class Mapping
{
  private const Str:Schema tables
  private const SlanCache cache

  new make(Schema[] list)
  {
    tables := Str:Schema[:]
    list.each
    {
      tables[it.name] = it
    }
    this.tables = tables
    cache = SlanCache()
  }

  virtual Schema get(Type type)
  {
    key := type.name
    if (tables.containsKey(key)) return tables[key]

    if (cache.containsKey(key))
    {
      return cache.get(key)
    }
    else
    {
      table := SqlUtil.mappingFromType(type)
      cache.set(key, table)
      return table
    }
  }

  Void each(|Schema| f)
  {
    tables.each(f)
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

