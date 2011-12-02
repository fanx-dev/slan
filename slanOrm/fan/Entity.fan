//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

**
** super class for entity,convenient but not necessary
** rename from 'Record'
**
mixin Entity
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
    context.deleteById(context.getTable(this.typeof), context.getId(this))
  }

  Entity[] list(Str orderby := "", Int offset := 0, Int limit := 50)
  {
    context.list(this, orderby, offset, limit)
  }

  Entity? one(Str orderby := "", Int offset := 0)
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
  Entity[] select(Str where, Int offset := 0, Int limit := 50)
  {
    context.select(context.getTable(this.typeof), where, offset)
  }

  ** static
  Entity? findById(Obj id)
  {
    context.findById(context.getTable(this.typeof), id)
  }

  ** static
  Void deleteById(Obj id)
  {
    context.deleteById(context.getTable(this.typeof), id)
  }
}