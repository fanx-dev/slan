//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

using isql
using slanData

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
  static Str makeKey(OSchema s, Obj obj)
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
    if (f.isPrimitive)
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
  static Bool checkMatchDb(OSchema s, Col[] tcols)
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
// Tools
//////////////////////////////////////////////////////////////////////////

  **
  ** auto mapping form type.
  ** table name default is podName+typeName.
  **
  static Schema mappingFromType(Type type)
  {
    Int? id
    cs := CField[,]
    Bool generateId := false

    type.fields.each |Field f|
    {
      //once method hide field that end with '$Store'
      if (!f.hasFacet(Transient#) && !f.isStatic && !f.name.endsWith("\$Store"))
      {
        if (f.hasFacet(Colu#))
        {
          Colu c := f.facet(Colu#)
          cs.add(OField(f, cs.size, c.name) { length = c.m; precision = c.d })
        }
        else if (f.hasFacet(Text#))
        {
          cs.add(OField(f, cs.size, null) { length = 1024 })
        }
        else
        {
          cs.add(OField(f, cs.size))
        }

        if (f.hasFacet(Id#))
        {
          id = cs.size-1
          Id idFacet := f.facet(Id#)

          //get autoGenerate strategy
          if (idFacet.generate != null)
          {
            generateId = idFacet.generate
          }
          else
          {
            if (f.type.toNonNullable == Int#){
              generateId = true
            }
          }
        }
      }
    }

    if (id == null)
    {
      throw MappingErr("Record must have Id, add @Id facet for field")
    }

    table := OSchema
    (
      type,
      type.name,
      cs,
      id,
      generateId
    )

    return table
  }

//////////////////////////////////////////////////////////////////////////
// schema
//////////////////////////////////////////////////////////////////////////

  static Schema colsToSchema(Str name, Col[] cols)
  {
    list := CField[,]
    cols.each |c, i|
    {
      list.add(fieldToCm(c, i))
    }
    return Schema(name, list)
  }

  static CField fieldToCm(Col col, Int index)
  {
    CField(col.name, col.type, index)
  }
}