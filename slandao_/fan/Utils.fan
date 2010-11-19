//
// Copyright (c) 2010, Yang Jiandong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Yang Jiandong  Creation
//

class Utils
{
  static StrBuf removeLastChar(StrBuf s){
    s.remove(s.size-1)
  }
  
  ** just a tool convert object to sql string
  static Str toSqlStr(Obj? o){
    if (o == null)     return "null"
    if (o is Str)      return "'$o'"
    if (o is DateTime) return "'" + o->toLocale("YYYY-MM-DD hh:mm:ss") + "'"
    if (o is Date)     return "'" + o->toLocale("YYYY-MM-DD") + "'"
    if (o is Time)     return "'" + o->toLocale("hh:mm:ss") + "'"
    return o.toStr
  }
}

const class MappingErr : Err{
  new make(Str m):super(m){
  }
}