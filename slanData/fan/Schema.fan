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
const class Schema
{
  private const Str:Int map := Str:Int[:]
  protected const CField[] columns := [,]

  const Str name
  const Int idIndex

  ** auto generate the key
  const Bool autoGenerateId

  new make(Str name, CField[] fields, Int idIndex := -1, Bool autoGenerateId := false)
  {
    this.columns = fields
    this.name = name
    this.idIndex = idIndex
    this.autoGenerateId = autoGenerateId

    fmap := Str:Int[:]
    columns.each |f, i|
    {
      if (f.index != i) throw ArgErr("field index must equals position")
      fmap[f.name] = i
    }
    this.map = fmap
  }

  Int size() { columns.size }
  CField get(Int i) { columns[i] }

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