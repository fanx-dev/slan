//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-11-20  Jed Young  Creation
//

mixin StrTool
{
  static Str bufToHex(Buf buf)
  {
    s := StrBuf()
    while (buf.more)
    {
      c := buf.readU1
      s.add(c.toHex)
    }
    return s.toStr
  }
}