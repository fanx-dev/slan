//
// Copyright (c) 2010, Yang Jiandong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Yang Jiandong  Creation
//
const class TableMaker
{
  Str createTable(Table table){
    sql:=StrBuf()
    sql.add("create table $table.name(")
    
    table.columns.each|Column c|{
      sqlType:=c.getSqlType(table.autoGenerateId==true && table.id==c )
      sql.add("$c.name $sqlType,")
    }
    
    if(table.id!=null){
      sql.add("primary key ($table.id.name)")
    }else{
       Utils.removeLastChar(sql)
    }
    
    sql.add(")")
    return sql.toStr
  }
  
  Str dropTable(Table table){
    return "drop table $table.name"
  }
}
