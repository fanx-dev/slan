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
internal class Util
{
  static Bool isPrimitiveType(Type type)
  {
    switch(type.toNonNullable)
    {
      case Int#:
        return true
      case Str#:
        return true
      case Float#:
        return true
      case Bool#:
        return true
      case DateTime#:
        return true
      case Date#:
        return true
      case Time#:
        return true
      case Decimal#:
        return true
      case Buf#:
        return true
      default:
        return false
    }
  }
}

