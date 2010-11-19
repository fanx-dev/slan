//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

internal const class TableMaker
{
  Str createTable(Table table)
  {
    sql := StrBuf()
    sql.add("create table $table.name(")
    
    table.columns.each |Column c|
    {
      sqlType := c.getSqlType( table.autoGenerateId == true && table.id == c )
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
