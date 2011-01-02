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

  ** length in [4...36]
  static Bool isIdentifier(Str text)
  {
    r := Regex<|^[a-zA-Z][a-zA-Z0-9_]{3,35}$|>
    return r.matches(text)
  }

  ////////////////////////////////////////////////////////////////////////
  // check
  ////////////////////////////////////////////////////////////////////////

  This email(Str text)
  {
    if (text.isEmpty) return this
    if (!isEmail(text)) throw ValidateErr("bad email format: $text")
    return this
  }

  This digit(Str text)
  {
    if (text.isEmpty) return this
    if (!isDigit(text)) throw ValidateErr("bad digit format: $text")
    return this
  }

  This uri(Str text)
  {
    if (text.isEmpty) return this
    if (!isUri(text)) throw ValidateErr("bad uri format: $text")
    return this
  }

  This identifier(Str text)
  {
    if (text.isEmpty) return this
    if (!isIdentifier(text)) throw ValidateErr("bad identifier format: $text")
    return this
  }

  This range(Int i, Range r)
  {
    if (!r.contains(i)) throw ValidateErr("$i out of $r")
    return this
  }

  This length(Str text, Range r)
  {
    if (!r.contains(text.size)) throw ValidateErr("the $text length out of $r")
    return this
  }

  This required(Str? text)
  {
    if (text == null || text.isEmpty) throw ValidateErr("the text is empty")
    return this
  }
}

const class ValidateErr : Err
{
  new make(Str msg) : super(msg) {}
}