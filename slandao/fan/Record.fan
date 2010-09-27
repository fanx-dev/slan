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
@Serializable
abstract class Record
{
  @Transient Context? ct
  
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
    return ct.list(this)
  }
  
  Bool exist(){
    return ct.exist(this)
  }
  
  Int count(){
    return ct.count(this)
  }
  
  This save(){
    ct.save(this)
    return this
  }
}
