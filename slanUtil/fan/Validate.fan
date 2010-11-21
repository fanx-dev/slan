//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-11-20  Jed Young  Creation
//

const class Validate
{
  static Bool isEmail(Str text)
  {
    r := Regex <|^(?:\w+\.?)*\w+@(?:\w+\.?)*\w+$|>
    return r.matches(text)
  }
}