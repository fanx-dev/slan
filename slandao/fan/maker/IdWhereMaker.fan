//
// Copyright (c) 2010 Yang Jiandong
// Licensed under Eclipse Public License version 1.0
//
// History:
//   yangjiandong 2010-9-22 - Initial Contribution
//


**
**
**
const class IdWhereMaker
{
  Str getSql(Table table){
    return "from $table.name where $table.id.name=@$table.id.name"
  }
  
  Str:Obj getParam(Table table,Obj id){
    Str:Obj param:=[:]
    param[table.id.name]=id
    return param
  }
}
