//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//


internal const class InsertMaker
{
  Str getSql(TableDef table)
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

  Obj?[] getParam(TableDef table, Obj obj)
  {
    param := Obj?[,]
    table.nonAutoGenerate |FieldDef c|
    {
      param.add(c.get(obj))
    }
    return param
  }
}

**************************************************************************
**
**************************************************************************

internal const class UpdateByIdMaker
{
  Str getSql(TableDef table,Obj obj)
  {
    sql := StrBuf()
    sql.add("update $table.name set ")

    table.nonIdColumn
    {
      if (it.get(obj) != null) {
        sql.add("$it.name=?,")
      }
    }

    Utils.removeLastChar(sql).add(" where ")
    sql.add("$table.id.name=?")

    return sql.toStr
  }

  Obj?[] getParam(TableDef table, Obj obj)
  {
    param := Obj?[,]
    table.nonIdColumn |c|
    {
      if (c.get(obj) != null) {
        param.add(c.get(obj))
      }
    }
    param.add(table.id.get(obj))
    return param
  }
}

internal const class UpdateMaker
{
  Str getSql(TableDef table, Obj obj)
  {
    sql := StrBuf()
    sql.add("update $table.name set ")

    table.each
    {
      if (it.get(obj) != null) {
        sql.add("$it.name=?,")
      }
    }

    Utils.removeLastChar(sql)
    return sql.toStr
  }

  Obj?[] getParam(TableDef table, Obj obj)
  {
    param := Obj?[,]
    table.each |c|
    {
      if (c.get(obj) != null) {
        param.add(c.get(obj))
      }
    }
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
  Str getSql(TableDef table, Obj obj)
  {
    condition := StrBuf().add("where ")
    Int count := 0
    table.each
    {
      if (it.get(obj) != null)
      {
        condition.add("$it.name=? and ")
        ++count
      }
    }
    if (count == 0){
      return ""
    }
    condition.removeRange(Range.makeInclusive(condition.size-5,-1))
    return "$condition"
  }

  Obj?[] getParam(TableDef table, Obj obj)
  {
    param := Obj?[,]
    table.each |c|
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
  Str getSql(TableDef table)
  {
    return "where $table.id.name=?"
  }

  Obj?[] getParam(TableDef table, Obj id)
  {
    return [id]
  }
}

**************************************************************************
**
**************************************************************************

internal const class SelectMaker
{
  Str getSql(TableDef table)
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