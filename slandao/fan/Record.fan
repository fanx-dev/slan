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
  
  Void deleteByExample(){
    ct.deleteByExample(this)
  }
  
  ** delete by id
  Void delete(){
    ct.deleteById(this.typeof,ct.getId(this))
  }
  
  Obj[] list(Str orderby:="",Int offset:=0,Int limit:=20){
    ct.list(this,orderby,offset,limit)
  }
  
  Obj? one(Str orderby:="",Int offset:=0){
    ct.one(this,orderby,offset)
  }
  
  ** no cache
  Bool exist(){
    ct.exist(this)
  }
  
  Int count(){
    ct.count(this)
  }
  
  ** insert or update
  This save(){
    ct.save(this)
    return this
  }
}
