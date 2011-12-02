//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

using slanData
using isql

class Utils
{
  static StrBuf removeLastChar(StrBuf s)
  {
    s.remove(s.size - 1)
  }
}

const class MappingErr : Err
{
  new make(Str m) : super(m) {}
}