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
const class FieldDef
{
  ** column name
  const Str name

  ** fantom type
  const Type type

  ** index in Schema
  const Int index

  ** sql type. if null will use type
  const Str? sqlType

  ** first parameter
  const Int? length

  ** second parameter
  const Int? precision

  ** hint to build index on this field
  const Bool indexed := false

  const Field? field

  new make(|This| f) { f(this) }

  virtual Obj? get(Obj obj)
  {
    if (obj is Record) {
      Record r := obj
      return r.get(index)
    }
    return field.get(obj)
  }

  virtual Void set(Obj obj, Obj? value)
  {
    if (obj is Record) {
      Record r := obj
      r.set(index, value)
    }
    field?.set(obj, value)
  }

  override Str toStr()
  {
    "$name $type.name"
  }
}