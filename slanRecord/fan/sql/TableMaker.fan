//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

using isql


internal const class TableMaker
{
  Str createTable(TableDef table, SqlDialect dialect)
  {
    sql := StrBuf()
    sql.add("create table $table.name(")

    table.each |c, i|
    {
      if (i != 0) {
        sql.add(",")
      }

      sql.add(dialect.escaptSqlWord(c.name)).add(" ")
      sql.add(dialect.getSqlType(c))

      if (table.autoGenerateId && table.id == c) {
        sql.add(" ")
        sql.add(dialect.autoIncrement)
      }
    }

    if (table.id != null) {
      sql.add(", PRIMARY KEY ($table.id.name)")
    }
    sql.add(")")
    return sql.toStr
  }



  Str createIndex(Str tableName, Str fieldName)
  {
    "create index index_${tableName}_${fieldName} on ${tableName} (${fieldName})"
  }

  Str dropTable(TableDef table)
  {
    return "drop table $table.name"
  }
}

