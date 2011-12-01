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
      fmap[f.name] = i
    }
    this.map = fmap
  }

  Int size() { columns.size }
  CField get(Int i) { columns[i] }

  Void each(|CField, Int| f)
  {
    columns.each |c, i| { f(c, i) }
  }

  CField find(Str name) { get(map[name]) }


  ** PK of this table
  CField? id()
  {
    if (idIndex == -1) return null
    return columns[idIndex]
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

**************************************************************************
** Field is column of datatable
**************************************************************************
@Js
const class CField
{
  const Str name
  const Type type
  const Int index

  new make(Str name, Type type, Int index)
  {
    this.name = name
    this.type = type
    this.index = index
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