//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

**
** super class for entity,convenient but not necessary
** 
mixin Record
{
  abstract Context context()
  
  This insert()
  {
    context.insert(this)
    return this
  }
  
  This update()
  {
    context.update(this)
    return this
  }
  
  Void deleteByExample()
  {
    context.deleteByExample(this)
  }
  
  ** delete by id
  Void delete()
  {
    context.deleteById(this.typeof, context.getId(this))
  }
  
  Record[] list(Str orderby := "", Int offset := 0, Int limit := 20)
  {
    context.list(this, orderby, offset, limit)
  }
  
  Record? one(Str orderby := "", Int offset := 0)
  {
    context.one(this, orderby, offset)
  }
  
  ** no cache
  Bool exist()
  {
    context.exist(this)
  }
  
  Int count()
  {
    context.count(this)
  }
  
  ** insert or update
  This save()
  {
    context.save(this)
    return this
  }
  
  ////////////////////////////////////////////////////////////////////////
  // static method
  ////////////////////////////////////////////////////////////////////////

  ** static
  Record[] select(Str where, Int offset := 0, Int limit := 20)
  {
    context.select(this.typeof, where, offset)
  }
  
  ** static
  Record? findById(Obj id)
  {
    context.findById(this.typeof, id)
  }
  
  ** static
  Void deleteById(Obj id)
  {
    context.deleteById(this.typeof, id)
  }
}
