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

  static Bool isDigit(Str text)
  {
    for (i := 0; i < text.size; i++)
    {
      if (!text[i].isDigit) return false
    }
    return true
  }

  static Bool isUri(Str text)
  {
    r := Regex<|^[a-zA-z]+://(\w+(-\w+)*)(\.(\w+(-\w+)*))*(\?\S*)?$|>
    return r.matches(text)
  }

  static Bool isIdentifier(Str text)
  {
    r := Regex<|^[a-zA-Z][a-zA-Z0-9_]{4,15}$|>
    return r.matches(text)
  }

  ////////////////////////////////////////////////////////////////////////
  // check
  ////////////////////////////////////////////////////////////////////////

  This verifyEmail(Str text)
  {
    if (!isEmail(text)) throw ValidateErr("bad email format: $text")
    return this
  }

  This verifyDigit(Str text)
  {
    if (!isDigit(text)) throw ValidateErr("bad digit format: $text")
    return this
  }

  This verifyUri(Str text)
  {
    if (!isUri(text)) throw ValidateErr("bad uri format: $text")
    return this
  }

  This verifyIdentifier(Str text)
  {
    if (!isIdentifier(text)) throw ValidateErr("bad identifier format: $text")
    return this
  }

  This verifyInRange(Int i, Range r)
  {
    if (!r.contains(i)) throw ValidateErr("$i out of $r")
    return this
  }

  This verifyLength(Str text, Range r)
  {
    if (!r.contains(text.size)) throw ValidateErr("the $text length out of $r")
    return this
  }

  This verifyNotEmpty(Str? text)
  {
    if (text == null || text.isEmpty) throw ValidateErr("the text is empty")
    return this
  }
}

const class ValidateErr : Err
{
  new make(Str msg) : super(msg) {}
}