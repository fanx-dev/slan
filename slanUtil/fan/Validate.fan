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
    r := Regex<|(\w+):\/\/([^\/:]+)(:\d*)?([^#]*)|>
    return r.matches(text)
  }

  ** YYYY-MM-DD
  static Bool isDate(Str text)
  {
    r := Regex<|^(\d{4})\-(\d{2})\-(\d{2})$|>
    return r.matches(text)
  }

  ** length in '[3...36]', start with char
  static Bool isIdentifier(Str text)
  {
    r := Regex<|[a-zA-Z0-9_-]{3,36}|>
    return r.matches(text)
  }

  ////////////////////////////////////////////////////////////////////////
  // check
  ////////////////////////////////////////////////////////////////////////

  This email(Str text)
  {
    if (text.isEmpty) return this
    if (!isEmail(text)) throw ValidateErr("Not a valid email: $text")
    return this
  }

  This digit(Str text)
  {
    if (text.isEmpty) return this
    if (!isDigit(text)) throw ValidateErr("Not a valid digit: $text")
    return this
  }

  This date(Str text)
  {
    if (text.isEmpty) return this
    if (!isDate(text)) throw ValidateErr("Not a valid date: $text")
    return this
  }

  This uri(Str text)
  {
    if (text.isEmpty) return this
    if (!isUri(text)) throw ValidateErr("Not a valid uri: $text")
    return this
  }

  This identifier(Str text)
  {
    if (text.isEmpty) return this
    if (!isIdentifier(text)) throw ValidateErr("Not a valid identifier: $text")
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
    if (text == null || text.isEmpty) throw ValidateErr("the text is required")
    return this
  }
}

const class ValidateErr : Err
{
  new make(Str msg) : super(msg) {}
}