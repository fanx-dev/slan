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
** Field is column of datatable
**
@Js
const class CField
{
  const Str name
  const Type type
  const Int index

  ** first parameter
  const Int? length

  ** second parameter
  const Int? precision

  ** field type is primitive ,like Int,Float,Str,DateTime...
  const Bool isPrimitive

  new make(Str name, Type type, Int index, |This|? f := null)
  {
    this.name = name
    this.type = type
    this.index = index
    f?.call(this)
    isPrimitive = Util.isPrimitiveType(type)
  }

  virtual Obj? get(Obj obj)
  {
    Record r := obj
    return r.get(index)
  }

  virtual Void set(Obj obj, Obj? value)
  {
    Record r := obj
    r.set(index, value)
  }
}