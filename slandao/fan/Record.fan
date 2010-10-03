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
  abstract Context c()
  
  This insert(){
    c.insert(this)
    return this
  }
  
  This update(){
    c.update(this)
    return this
  }
  
  Void delete(){
    c.delete(this)
  }
  
  Obj[] select(){
    return c.select(this)
  }
  
  Obj? one(){
    return c.one(this)
  }
  
  Bool exist(){
    return c.exist(this)
  }
  
  Int count(){
    return c.count(this)
  }
  
  This save(){
    c.save(this)
    return this
  }
}
