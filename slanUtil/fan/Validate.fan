//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-11-20  Jed Young  Creation
//

mixin Validate
{
  static Bool isEmail(Str text)
  {
    r := Regex <|^(?:\w+\.?)*\w+@(?:\w+\.?)*\w+$|>
    return r.matches(text)
  }

  This verifyEmail(Str text)
  {
    if (!isEmail(text)) throw ValidateErr("bad email format")
    return this
  }

  static Bool isDigit(Str text)
  {
    for (i := 0; i < text.size; i++)
    {
      if (!text[i].isDigit) return false
    }
    return true
  }

  This verifyDigit(Str text)
  {
    if (!isDigit(text)) throw ValidateErr("bad digit format")
    return this
  }
}

const class ValidateErr : Err
{
  new make(Str msg) : super(msg) {}
}