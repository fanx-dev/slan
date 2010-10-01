//
// Copyright (c) 2010, Yang Jiandong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Yang Jiandong  Creation
//
const class UpdateMaker
{
  Str getSql(Table table,Obj obj){
    sql:=StrBuf()
    sql.add("update $table.name set ")
    
    table.nonIdColumn{
      if(it.field.get(obj)!=null){
        sql.add("$it.name=@$it.name,")
      }
    }
    
    Utils.removeLastChar(sql).add(" where ")
    sql.add("$table.id.name=@$table.id.name")
    
    return sql.toStr
  }
  
  Str:Obj getParam(Table table,Obj obj){
    Str:Obj param:=[:]
    table.columns.each|Column c|{
      value:=c.getValue(obj)
      if(value!=null){
        param[c.name]=value
      }
    }
    return param
  }
}
