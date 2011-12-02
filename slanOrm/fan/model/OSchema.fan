//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

using isql
using slanData

**
** mapping model for database table.
** must has a prime key.
**
const class OSchema : Schema
{
  ** Entity type
  const Type type

  new make(Type type, Str name, CField[] fields, Int idIndex := -1, Bool autoGenerateId := false)
    : super(name, fields, idIndex, autoGenerateId)
  {
    this.type = type
    if (!type.hasFacet(Serializable#))
    {
        throw MappingErr("class $type.name must be Serializable.
                          please using @Ignore for Ignore")
    }
  }

//////////////////////////////////////////////////////////////////////////
// Mmethod
//////////////////////////////////////////////////////////////////////////

  **
  ** fetch data
  **
  Obj getInstance(Row r)
  {
    obj := type.make
    columns.each |CField c, Int i|
    {
      value := r[i]
      c.set(obj, value)
    }
    return obj
  }
}