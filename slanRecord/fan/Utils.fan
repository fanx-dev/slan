//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

using isql

class Utils
{
  static StrBuf removeLastChar(StrBuf s)
  {
    s.remove(s.size - 1)
  }

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

const class MappingErr : Err
{
  new make(Str m) : super(m) {}
}