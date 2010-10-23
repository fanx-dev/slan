//
// Copyright (c) 2010 Yang Jiandong
// Licensed under Eclipse Public License version 1.0
//
// History:
//   yangjiandong 2010-10-22 - Initial Contribution
//


**
** convenient for type query
**
const class Dao
{
  const Type type
  const Context context
  
  new make(Type type,Context context){
    this.type=type
    this.context=context
  }
  
  Obj[] select(Str where,Int offset:=0,Int limit:=20){
    context.select(type,where,offset)
  }
  
  Obj? get(Obj id){
    context.findById(type,id)
  }
  
  Void delete(Obj id){
    context.deleteById(type,id)
  }
}
