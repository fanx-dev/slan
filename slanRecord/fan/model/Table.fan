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
** Schema is a metadata of records
**
@Js
@Serializable
const class Table
{
  @Transient
  const private Str:Int map

  const protected Column[] columns

  const Str name
  const Int idIndex := -1
  const Type type

  ** auto generate the key
  const Bool autoGenerateId := false

  new make(|This| f) {
    f(this)

    fmap := Str:Int[:]
    columns.each |field, i| {
      fmap[field.name] = i
      if (field.index != i) {
        throw ArgErr("field index error. $field: $field.index != $i")
      }
    }
    map = fmap
  }

  Int size() { columns.size }
  Column get(Int i) { columns[i] }

  Void each(|Column, Int| f)
  {
    columns.each(f)
  }

  Column find(Str name)
  {
    i := map[name]
    if (i == null) {
      throw Err("not found $name")
    }
    return get(i)
  }


  ** PK of this table
  Column? id()
  {
    if (idIndex == -1) return null
    return columns[idIndex]
  }

  virtual Obj newInstance()
  {
    m := type.method("make").params
    if (m.size == 0) {
      return type.make([,])
    } else {
      return type.make([this])
    }
  }

  override Str toStr()
  {
    s := StrBuf()
    s.add(name)
    s.join(idIndex)
    s.add("(")
    each |f|
    {
      s.add(f.toStr)
      s.add(",")
    }
    s.add(")")
    return s.toStr
  }

//////////////////////////////////////////////////////////////////////////
// Each
//////////////////////////////////////////////////////////////////////////

  ** Each Columns except id
  Void nonIdColumn(|Column| f)
  {
    columns.each
    {
      if (it != id)
      {
        f(it)
      }
    }
  }

  ** Each Columns except auto generate field
  Void nonAutoGenerate(|Column| f)
  {
    if (autoGenerateId == true)
    {
      nonIdColumn(f)
    }
    else
    {
      columns.each(f)
    }
  }
}