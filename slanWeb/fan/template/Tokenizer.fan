//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

**
** Tokenizer
**
** @name/@{name} => + m->name +
** ${name} => + Pod.find("podName").locale("name") +
**
internal class Tokenizer
{
  private const Log log := Pod.of(this).log

  private const Str str
  private const Int len

  private Int start
  private Int current
  private Str char

  private Int mode
  private Int preMode
  private Bool valid := true

  new make(Str str)
  {
    this.str = str
    len = str.size

    start = 0
    current = 0
    char = str[0].toChar

    mode = textMode
    valid = true
  }

  ////////////////////////////////////////////////////////////////////////
  // covert
  ////////////////////////////////////////////////////////////////////////

  public static Str convert(Str oldStr, Str podName)
  {
    tok := Tokenizer(oldStr)
    buf := StrBuf()
    s := tok.next
    while(s != null)
    {
      //echo("********$s")
      code := getCode(tok, s, podName)
      buf.add(code)
      s = tok.next
    }
    return buf.toStr
  }

  //private static Str triple = Str<|"""|>

  private static Str getCode(Tokenizer tok, Str s, Str podName)
  {
    Str code := ""
    switch(tok.preMode)
    {
      case textMode:
        code = s
      case paramMode:
        if (tok.valid)
          code = "\${m->${s}.toStr.toXml}"
        else
          code = s
      case localeMode:
        if (tok.valid)
        {
          if (s.contains("::"))
            code = "\$<$s>"
          else
            code = "\$<$podName::$s>"
        }else
          code = s
    }
    return code
  }

  ////////////////////////////////////////////////////////////////////////
  // token
  ////////////////////////////////////////////////////////////////////////

  public Str? next()
  {
    start = current
    valid = true
    preMode = mode

    switch (mode)
    {
      case textMode: return text();
      case paramMode: return param();
      case localeMode: return locale();
      case endMode: return null;
      default: return null;
    }
  }

  private Str text()
  {
    while (hasMore)
    {
      switchMode
      if (mode != textMode) return str[start..<current]
      moveNext
    }

    //the end
    mode = endMode;
    return str[start..-1]
  }

  private Str param()
  {
    //not has more
    if (!hasMore)
    {
      mode = endMode
      valid = false
      return "@"
    }

    //move to next
    moveNext

    // @@ means we really wanted @
    if (char == "@")
    {
      moveNext
      mode = textMode
      valid = false
      return "@";
    }

    //like @{
    if (char == "{")
      return bracketParam

    //like @name
    if (isIdentifier(char))
      return identifierParam

    //not valid char identifier
    switchMode
    valid = false
    return "@"
  }

  private Str identifierParam()
  {
    while (moveNext)
    {
      if (!isIdentifier(char))
      {
        if (char == "-" && peek == ">")
        {
          moveNext
          continue
        }
        switchMode
        return str[start+1..<current]
      }
    }
    mode = endMode
    return str[start+1..-1]
  }

  private Str bracketParam()
  {
    while (moveNext)
    {
      if (char == "}")
      {
        if(!moveNext)
        {
          mode = endMode
          return str[start+2..<current]
        }
        switchMode
        return str[start+2..<current-1]
      }
    }
    throw SlanTokenErr("expected '}'")
  }

  private Str locale()
  {
    //not has more
    if (!hasMore)
    {
      mode = endMode
      valid = false
      return "\$"
    }

    moveNext

    //$$
    if (char == "\$")
    {
      moveNext
      mode = textMode
      valid = false
      return "\$"
    }

    if (char != "<")
    {
      switchMode
      valid = false
      return "\$"
    }

    while (moveNext)
    {
      if (char == ">")
      {
        if (!moveNext)
        {
          mode = endMode
          return str[start+2..<current]
        }
        switchMode
        return str[start+2..<current-1]
      }
    }

    throw SlanTokenErr("expected '>'")
  }

  private Void switchMode()
  {
    switch(char)
    {
      case "@":
        mode = paramMode
      case "\$":
        mode = localeMode
      default:
        mode = textMode
    }
  }

  ////////////////////////////////////////////////////////////////////////
  // tools
  ////////////////////////////////////////////////////////////////////////

  private Str? previous()
  {
    if (current > 0) return str[current-1].toChar
    return null
  }

  private Str? peek()
  {
    if (current >= str.size) return null
    return str[current+1].toChar
  }

  private static Bool isIdentifier(Str char)
  {
    return (char.isAlphaNum() || char == "_" || char == ".")
  }

  private Str removeChar(Str old, Int i)
  {
    s := StrBuf()
    s.add(old)
    return s.remove(i).toStr
  }

  private Bool hasMore()
  {
    current + 1 < len
  }

  private Bool moveNext()
  {
    if (!hasMore) return false
    current++
    char = str[current].toChar
    return true
  }

  private static const Int textMode := 1
  private static const Int paramMode := 2
  private static const Int localeMode := 3
  private static const Int endMode := 4
}

**************************************************************************
**************************************************************************

const class SlanTokenErr : ParseErr
{
  new make(Str msg) : super(msg) {}
}