//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

using slanData


const class Mapping
{
  const Str:Schema tables
  private const Schema[] list

  new make(Schema[] list)
  {
    this.list = list
    tables := Str:Schema[:]
    list.each
    {
      tables[it.name] = it
    }
    this.tables = tables
  }

  virtual Schema getTableByType(Type type)
  {
    getTableByName(type.name)
  }

  virtual Schema getTableByObj(Obj obj)
  {
    Record r := obj
    return getTableByName(r.schema.name)
  }

  virtual Schema getTableByName(Str name)
  {
    tables[name]
  }

  Void each(|Schema, Int| f)
  {
    list.each(f)
  }
}

const class OMapping : Mapping
{
  const [Type:Schema]? tTables

  new make(OSchema[] list) : super(list)
  {
    tables := Type:Schema[:]
    list.each
    {
      tables[it.type] = it
    }
    this.tTables = tables
  }

  override Schema getTableByType(Type type)
  {
    tTables[type]
  }

  override Schema getTableByObj(Obj obj)
  {
    getTableByType(obj.typeof)
  }
}