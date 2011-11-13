//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

internal const class InsertMaker
{
  Str getSql(Table table)
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

  Obj?[] getParam(Table table, Obj obj)
  {
    param := Obj?[,]
    table.nonAutoGenerate |Column c|
    {
      param.add(c.getValue(obj))
    }
    return param
  }
}

**************************************************************************
**
**************************************************************************

internal const class UpdateMaker
{
  Str getSql(Table table,Obj obj)
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

  Obj?[] getParam(Table table, Obj obj)
  {
    param := Obj?[,]
    table.nonIdColumn |Column c|
    {
      param.add(c.getValue(obj))
    }
    param.add(table.id.getValue(obj))
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
  Str getSql(Table table, Obj obj)
  {
    from := " from $table.name"
    condition := StrBuf()
    table.columns.each
    {
      if (it.field.get(obj) != null)
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

  Obj?[] getParam(Table table, Obj obj)
  {
    param := Obj?[,]
    table.columns.each |Column c|
    {
      value := c.getValue(obj)
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

internal const class TableMaker
{
  Str createTable(Table table)
  {
    sql := StrBuf()
    sql.add("create table $table.name(")

    table.columns.each |Column c|
    {
      sqlType := c.getSqlType( table.autoGenerateId && table.id == c )
      sql.add("$c.name $sqlType,")
    }
    sql.add("primary key ($table.id.name)")
    sql.add(")")
    return sql.toStr
  }

  Str dropTable(Table table)
  {
    return "drop table $table.name"
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
  Str getSql(Table table)
  {
    return " from $table.name $table.id.name=?"
  }

  Obj?[] getParam(Table table, Obj id)
  {
    return [id]
  }
}

**************************************************************************
**
**************************************************************************

internal const class SelectMaker
{
  Str getSql(Table table)
  {
    sql := StrBuf()
    sql.add("select ")

    table.columns.each
    {
      sql.add("$it.name,")
    }

    Utils.removeLastChar(sql)
    return sql.toStr
  }
}