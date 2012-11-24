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

  new makeNew(Type type, Str name, CField[] fields, Int idIndex := -1, Bool autoGenerateId := false)
    : super.makeNew(name, fields, idIndex, autoGenerateId)
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

  override Obj newInstance()
  {
    return type.make
  }

}