//
// Copyright (c) 2010, Yang Jiandong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Yang Jiandong  Creation
//
**
** super class for entity
** 
@Ignore
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
  
  Obj[] select(){
    ct.select(this)
  }
  
  Obj? one(){
    ct.one(this)
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
