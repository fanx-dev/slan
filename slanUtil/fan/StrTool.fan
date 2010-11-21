//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-11-20  Jed Young  Creation
//

const class StrTool
{
  static Str encrypt(Str text)
  {
    key := text.toBuf.hmac("MD5", "secret".toBuf)
    s2 := text.toBuf.hmac("SHA1", key)
    s3 := s2.hmac("MD5", key)

    return BufToStr(s3)
  }

  static Str BufToStr(Buf buf)
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