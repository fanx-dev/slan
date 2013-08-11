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
class Schema
{
  @Transient
  private Str:Int map := Str:Int[:]

  protected CField[] columns := [,]

  Str name
  Int idIndex := -1
  Type type

  ** auto generate the key
  Bool autoGenerateId := false

  new make(|This| f) { f(this) }

  new makeNew(Str name, Type type := ArrayRecord#)
  {
    this.name = name
    this.type = type;
  }

  Int size() { columns.size }
  CField get(Int i) { columns[i] }

  @Operator
  This add(CField f)
  {
    columns.add(f)
    f.index = columns.size-1
    map[f.name] = f.index
    return this
  }

  Void each(|CField, Int| f)
  {
    columns.each(f)
  }

  CField find(Str name) { get(map[name]) }


  ** PK of this table
  CField? id()
  {
    if (idIndex == -1) return null
    return columns[idIndex]
  }

  virtual Obj newInstance()
  {
    return type.make([this])
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
  Void nonIdColumn(|CField| f)
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
  Void nonAutoGenerate(|CField| f)
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