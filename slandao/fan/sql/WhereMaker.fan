//
// Copyright (c) 2010, Yang Jiandong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Yang Jiandong  Creation
//

**
** make condition ,the object as a template
** 
internal const class WhereMaker
{
  Str getSql(Table table,Obj obj){
    sql:=StrBuf()
    sql.add("from $table.name where")
    
    table.columns.each{
      if(it.field.get(obj)!=null){
        sql.add(" $it.name=@$it.name and")
      }
    }
    
    sql.removeRange(Range.makeInclusive(sql.size-4,-1))
    return sql.toStr
  }
  
  Str:Obj getParam(Table table,Obj obj){
    Str:Obj param:=[:]
    table.columns.each |Column c|{
      value:=c.getValue(obj)
      if(value!=null){
        param[c.name]=value
      }
    }
    return param
  }
}
