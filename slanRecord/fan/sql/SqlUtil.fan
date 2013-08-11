//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

using isql

**
** mapping model for database table.
** must has a prime key.
**
const class SqlUtil
{
  const static Log log := SqlUtil#.pod.log

  ** just a tool convert object to sql string
  static Str toSqlStr(Obj? o)
  {
    if (o == null)     return "null"
    if (o is Str)      return "'$o'"
    if (o is DateTime) return "'" + o->toLocale("YYYY-MM-DD hh:mm:ss") + "'"
    if (o is Date)     return "'" + o->toLocale("YYYY-MM-DD") + "'"
    if (o is Time)     return "'" + o->toLocale("hh:mm:ss") + "'"
    return o.toStr
  }

  **
  ** make string from object for cache key
  **
  static Str makeKey(Schema s, Obj obj)
  {
    condition := StrBuf()
    s.each |CField c|
    {
      value := c.get(obj)
      if (value != null)
      {
        condition.add("$c.name=$value&")
      }
    }
    return condition.toStr
  }

  **
  ** fetch data
  **
  static Obj getInstance(Schema s, ResultSet r)
  {
    obj := s.newInstance
    s.each |CField c, Int i|
    {
      value := r.get(i)
      c.set(obj, value)
    }
    return obj
  }

//////////////////////////////////////////////////////////////////////////
// MatchDb
//////////////////////////////////////////////////////////////////////////

  ** check the column is match the database
  static Bool checkMatchDbField(CField f, Col c)
  {
    if (!c.name.equalsIgnoreCase(f.name)) return false
    if (Utils.isPrimitiveType(f.type))
    {
      return c.type.qname == f.type.qname
    }
    if (f.type.isEnum)
    {
      return c.type.qname == Int#.qname
    }
    return c.type.qname == Str#.qname
  }

  **
  ** check model is match the database
  **
  static Bool checkMatchDb(Schema s, Col[] tcols)
  {
    if (s.size > tcols.size)
    {
      log.warn("model have $s.size field,but database $tcols.size")
      return false
    }

    errCount := 0
    s.each |CField c, Int i|
    {
      pass := checkMatchDbField(c, tcols[i])
      if (!pass)
      {
        log.warn("table $s.name field ${s.get(i).name} miss the database")
        errCount++
      }
    }
    if (errCount > 0)
    {
      return false
    }
    return true
  }

//////////////////////////////////////////////////////////////////////////
// schema
//////////////////////////////////////////////////////////////////////////

  static Schema colsToSchema(Str name, Col[] cols)
  {
    schema := Schema(name)
    cols.each |col|
    {
      schema.add(CField(col.name, col.type))
    }
    return schema
  }

}