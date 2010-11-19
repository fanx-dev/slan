//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//


**
** by ID
**
internal const class IdWhereMaker
{
  Str getSql(Table table)
  {
    return "from $table.name where $table.id.name=@$table.id.name"
  }
  
  Str:Obj getParam(Table table, Obj id)
  {
    Str:Obj param := [:]
    param[table.id.name] = id
    return param
  }
}
