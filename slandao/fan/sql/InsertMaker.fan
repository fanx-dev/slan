//
// Copyright (c) 2010, Yang Jiandong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Yang Jiandong  Creation
//
internal const class InsertMaker
{
  Str getSql(Table table){
    sql:=StrBuf()
    sql.add("insert into $table.name(")
    
    table.nonAutoGenerate{
      sql.add(it.name+",")
    }
    Utils.removeLastChar(sql).add(")values(")
    
    table.nonAutoGenerate{
      sql.add("@$it.name,")
    }
    Utils.removeLastChar(sql).add(")")
    
    return sql.toStr
  }
  
  Str:Obj getParam(Table table,Obj obj){
    Str:Obj? param:=[:]
    table.nonAutoGenerate|Column c|{
      param[c.name]=c.getValue(obj)
    }
    return param
  }
}
