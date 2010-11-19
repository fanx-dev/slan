//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

class Utils
{
  static StrBuf removeLastChar(StrBuf s)
  {
    s.remove(s.size - 1)
  }

  ** just a tool convert object to sql string
  static Str toSqlStr(Obj? o)
  {
    if (o == null)     return "null"
    if (o is Str)      return "'$o'"
    if (o is DateTime) return "'" + o->toLocale("YYYY-MM-DD hh:mm:ss") + "'"
    if (o is Date)     return "'" + o->toLocale("YYYY-MM-DD") + "'"
    if (o is Time)     return "'" + o->toLocale("hh:mm:ss") + "'"
    return o.toStr
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
      default:
        return false
    }
  }
}

const class MappingErr : Err
{
  new make(Str m) : super(m) {}
}