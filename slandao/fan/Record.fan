//
// Copyright (c) 2010, Yang Jiandong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Yang Jiandong  Creation
//
**
** super class for entity,convenient but not necessary
** 
mixin Record
{
  abstract Context ct()
  
  This insert(){
    ct.insert(this)
    return this
  }
  
  This update(){
    ct.update(this)
    return this
  }
  
  Void delete(){
    ct.delete(this)
  }
  
  Obj[] select(Str orderby:="",Int offset:=0,Int limit:=20){
    ct.select(this,orderby,offset,limit)
  }
  
  Obj? one(Str orderby:="",Int offset:=0){
    ct.one(this,orderby,offset)
  }
  
  Bool exist(){
    ct.exist(this)
  }
  
  Int count(){
    ct.count(this)
  }
  
  This save(){
    ct.save(this)
    return this
  }
}
