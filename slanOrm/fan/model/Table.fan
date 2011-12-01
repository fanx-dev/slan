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
const class Table : Schema
{
  ** Entity type
  const Type type

  private const Log log := Pod.of(this).log

  new make(Type type, Str name, CField[] fields, Int idIndex := -1, Bool autoGenerateId := false)
    : super(name, fields, idIndex, autoGenerateId)
  {
    this.type = type
    if (!type.hasFacet(Serializable#))
    {
        throw MappingErr("class $type.name must be Serializable.
                          please using @Ignore for Ignore")
    }
  }

//////////////////////////////////////////////////////////////////////////
// Mmethod
//////////////////////////////////////////////////////////////////////////

  **
  ** fetch data
  **
  Obj getInstance(Row r)
  {
    obj := type.make
    columns.each |Column c, Int i|
    {
      value := r[i]
      c.set(obj, value)
    }
    return obj
  }

  **
  ** make string from object for cache key
  **
  Str makeKey(Obj obj)
  {
    condition := StrBuf()
    columns.each |Column c|
    {
      value := c.get(obj)
      if (value != null)
      {
        condition.add("$c.name=$value&")
      }
    }
    return condition.toStr
  }

//////////////////////////////////////////////////////////////////////////
// MatchDb
//////////////////////////////////////////////////////////////////////////

  **
  ** check model is match the database
  **
  Bool checkMatchDb(Col[] tcols)
  {
    if (columns.size > tcols.size)
    {
      log.warn("model have $columns.size field,but database $tcols.size")
      return false
    }

    errCount := 0
    columns.each |Column c, Int i|
    {
      pass := c.checkMatchDb(tcols[i])
      if (!pass)
      {
        log.warn("table $name field ${columns[i].name} miss the database")
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
  static Table mappingFromType(Type type, SlanDialect dialect)
  {
    Int? id
    cs := Column[,]
    Bool generateId := false

    type.fields.each |Field f|
    {
      //once method hide field that end with '$Store'
      if (!f.hasFacet(Transient#) && !f.isStatic && !f.name.endsWith("\$Store"))
      {
        if (f.hasFacet(Colu#))
        {
          Colu c := f.facet(Colu#)
          cs.add(Column(f, dialect, cs.size, c.name, c.m, c.d))
        }
        else if (f.hasFacet(Text#))
        {
          cs.add(Column(f, dialect, cs.size, null, 1024))
        }
        else
        {
          cs.add(Column(f, dialect, cs.size))
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

    table := Table
    (
      type,
      type.name,
      cs,
      id,
      generateId
    )

    return table
  }
}