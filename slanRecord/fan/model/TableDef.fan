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
const class TableDef
{
  @Transient
  const private Str:Int map

  const FieldDef[] columns

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
  FieldDef get(Int i) { columns[i] }

  Void each(|FieldDef, Int| f)
  {
    columns.each(f)
  }

  FieldDef find(Str name)
  {
    i := map[name]
    if (i == null) {
      throw Err("not found $name")
    }
    return get(i)
  }


  ** PK of this table
  FieldDef? id()
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
  Void nonIdColumn(|FieldDef| f)
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
  Void nonAutoGenerate(|FieldDef| f)
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

class TableDefBuilder {
  Str name
  Int idIndex := -1
  Type type
  Bool autoGenerateId := false

  FieldDef[] columns := FieldDef[,]

  new make(Str name, Type type := ArrayRecord#) {
    this.name = name
    this.type = type
  }

  This add(FieldDef f) {
    addColumn(f.name, f.type, f.indexed, f.sqlType, f.length, f.precision)
  }

  This addColumn(Str name, Type type, Bool indexed := false, Str? sqlType := null, Int? length := null, Int? precision := null) {
    c := FieldDef {
      it.name = name
      it.type = type
      it.index = columns.size
      it.indexed = indexed
      it.sqlType = sqlType
      it.length = length
      it.precision = precision
    }
    columns.add(c)
    return this
  }

  TableDef build() {
    TableDef {
      it.name = this.name
      it.idIndex = this.idIndex
      it.type = this.type
      it.autoGenerateId = this.autoGenerateId

      it.columns = this.columns
    }
  }
}