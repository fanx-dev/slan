//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//


internal const class InsertMaker
{
  Str getSql(Schema table)
  {
    sql := StrBuf()
    sql.add("insert into $table.name(")

    table.nonAutoGenerate
    {
      sql.add(it.name+",")
    }
    Utils.removeLastChar(sql).add(")values(")

    table.nonAutoGenerate
    {
      sql.add("?,")
    }
    Utils.removeLastChar(sql).add(")")

    return sql.toStr
  }

  Obj?[] getParam(Schema table, Obj obj)
  {
    param := Obj?[,]
    table.nonAutoGenerate |CField c|
    {
      param.add(c.get(obj))
    }
    return param
  }
}

**************************************************************************
**
**************************************************************************

internal const class UpdateMaker
{
  Str getSql(Schema table,Obj obj)
  {
    sql := StrBuf()
    sql.add("update $table.name set ")

    table.nonIdColumn
    {
      sql.add("$it.name=?,")
    }

    Utils.removeLastChar(sql).add(" where ")
    sql.add("$table.id.name=?")

    return sql.toStr
  }

  Obj?[] getParam(Schema table, Obj obj)
  {
    param := Obj?[,]
    table.nonIdColumn |CField c|
    {
      param.add(c.get(obj))
    }
    param.add(table.id.get(obj))
    return param
  }
}

**************************************************************************
**
**************************************************************************

**
** make condition ,the object as a template
**
internal const class WhereMaker
{
  Str getSql(Schema table, Obj obj)
  {
    from := " from $table.name"
    condition := StrBuf()
    table.each
    {
      if (it.get(obj) != null)
      {
        condition.add("$it.name=? and ")
      }
    }
    if (condition.size == 0){
      return from
    }
    condition.removeRange(Range.makeInclusive(condition.size-5,-1))
    return "$from where $condition"
  }

  Obj?[] getParam(Schema table, Obj obj)
  {
    param := Obj?[,]
    table.each |CField c|
    {
      value := c.get(obj)
      if (value != null)
      {
        param.add(value)
      }
    }
    return param
  }
}

**************************************************************************
**
**************************************************************************

**
** by ID
**
internal const class IdWhereMaker
{
  Str getSql(Schema table)
  {
    return " from $table.name where $table.id.name=?"
  }

  Obj?[] getParam(Schema table, Obj id)
  {
    return [id]
  }
}

**************************************************************************
**
**************************************************************************

internal const class SelectMaker
{
  Str getSql(Schema table)
  {
    sql := StrBuf()
    sql.add("select ")

    table.each
    {
      sql.add("${table.name}.$it.name,")
    }

    Utils.removeLastChar(sql)
    return sql.toStr
  }
}