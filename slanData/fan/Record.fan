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
** Record is a data row of datatable
**
@Js
@Serializable
class Record
{
  Schema schema { private set }
  private Obj?[] values

  new make(Schema s, Obj?[]? vals := null)
  {
    schema = s
    if (vals != null) values = vals
    else
    {
      values = [,]
      values.size = schema.size
    }
  }

  Obj? get(Int i) { values[i] }
  Void set(Int i, Obj? value) { values[i] = value }
}

