//
// Copyright (c) 2009-2011, chunquedong
//
// This file is part of ChunMap project
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE(Version >=3)
//
// History:
//   2011-05-03  Jed Young  Creation
//

**
** Record is a data row of datatable
**
@Js
@Serializable
mixin Record
{
  @Transient
  abstract Schema schema

  abstract Obj? get(Int i)
  abstract Void set(Int i, Obj? value)

  Obj? getId()
  {
    idf := schema.id
    if (idf == null) return null
    return get(idf.index)
  }
}

@Js
@Serializable
class ArrayRecord : Record
{
  @Transient
  override Schema schema

  Obj?[] values := [,]

  new make(Schema s)
  {
    schema = s
    values.size = s.size
  }

  override Obj? get(Int i) { values[i] }
  override Void set(Int i, Obj? value) { values[i] = value }

  override Obj? trap(Str name, Obj?[]? args := null)
  {
    m := this.typeof.slot(name, false)
    if (m != null) {
      return super.trap(name, args)
    }
    if (args == null) {
      return get(schema.find(name).index)
    } else {
      set(schema.find(name).index, args)
      return null
    }
  }
}


