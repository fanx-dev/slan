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

  static StrBuf removeLastChar(StrBuf s)
  {
    s.remove(s.size - 1)
  }

  static Bool isPrimitiveType(Type type)
  {
    switch(type.toNonNullable)
    {
      case Int#:
        return true
      case Str#:
        return true
      case Float#:
        return true
      case Bool#:
        return true
      case DateTime#:
        return true
      case Date#:
        return true
      case TimeOfDay#:
        return true
      case Decimal#:
        return true
      case Buf#:
        return true
      default:
        return false
    }
  }

  ** convert object to sql string
  static Str toSqlStr(Obj? o)
  {
    if (o == null)     return "null"
    if (o is Str)      return "'$o'"
    if (o is DateTime) return "'" + o->toLocale("YYYY-MM-DD hh:mm:ss") + "'"
    if (o is Date)     return "'" + o->toLocale("YYYY-MM-DD") + "'"
    if (o is TimeOfDay)     return "'" + o->toLocale("hh:mm:ss") + "'"
    return o.toStr
  }

  **
  ** make string from object for cache key
  **
  static Str makeCacheKey(TableDef s, Obj obj)
  {
    condition := StrBuf()
    s.each |c|
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
  static Obj getInstance(TableDef s, ResultSet r)
  {
    obj := s.newInstance
    s.each |c, Int i|
    {
      value := r.get(i)
      if (c.field != null) {
        if (value is Int && c.field.type.fits(Enum#)) {
          Obj[] vals := c.field.type.field("vals").get
          value = vals[(Int)value]
        }
      }
      c.set(obj, value)
    }
    return obj
  }

  static Obj?[]? convertParams(Obj?[]? params) {
    if (params == null) return null
    params.each |p, i| {
      if (p != null && p is Enum) {
          p = (p as Enum).ordinal
          params[i] = p
      }
    }
    return params
  }

//////////////////////////////////////////////////////////////////////////
// MatchDb
//////////////////////////////////////////////////////////////////////////

  ** check the column is match the database
  static Bool checkMatchDbField(FieldDef f, Col c)
  {
    if (!c.name.equalsIgnoreCase(f.name)) return false
    if (isPrimitiveType(f.type))
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
  static Bool checkMatchDb(TableDef s, Col[] tcols)
  {
    if (s.size > tcols.size)
    {
      log.warn("model have $s.size field,but database $tcols.size")
      return false
    }

    errCount := 0
    s.each |FieldDef c, Int i|
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

  static TableDef colsToSchema(Str name, Col[] cols)
  {
    builder := TableDefBuilder(name, ArrayRecord#)
    cols.each |col, i|
    {
      builder.addColumn(col.name.lower, col.type)
    }
    return builder.build
  }

}