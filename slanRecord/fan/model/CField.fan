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
@Serializable
class CField
{
  Str name
  Type type
  Int index := -1
  Str? sqlType

  ** first parameter
  Int? length

  ** second parameter
  Int? precision

  ** hint to build index on this field
  Bool indexed := false

  new make(|This| f) { f(this) }

  new makeNew(Str name, Type type)
  {
    this.name = name
    this.type = type
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

  override Str toStr()
  {
    "$name $type.name"
  }
}