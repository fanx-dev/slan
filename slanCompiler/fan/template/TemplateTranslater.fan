//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

using web
using concurrent

**
** tranform form template to fantom sources string
**
internal const class TemplateTranslater
{
  ** shift for mutil line string
  private const Str gap := "\n    "
  private const Str codeGap := gap + Str.spaces(19)
  private const Log log := Pod.of(this).log

  private const Str? podName

  new make(Str? podName := null)
  {
    this.podName = podName
  }

  Str translate(Str code)
  {
    all := convertTemplate(code)

    s := "using web
          using slanCompiler

          const class HtmlTemplet : ${TemplateWeblet#.name}
          {
            Void dump(|->|? lay)
            {
              WebOutStream out := req.stash[\"_out\"] ?: res.out
              $all
            }
          }"
    
    if (podName != null)
    {
      s = "using $podName\n" + s
    }

    log.debug(s)
    return s
  }

  Str translateFanx(Str code)
  {
    all := convertTemplate(code)

    s := "using web
          using slanCompiler

          const class HtmlTemplet : ${TemplateWeblet#.name}
          {
            fun dump(lay: |->|?)
            {
              out : WebOutStream  = req.stash[\"_out\"] ?: res.out
              $all
            }
          }"

    if (podName != null)
    {
      s = "using $podName\n" + s
    }

    log.debug(s)
    return s
  }

  ** Tokenize
  private Str convertTemplate(Str code)
  {
    all := Buf()
    code.in.eachLine
    {
      all.writeChars(parse(it,"#"))
    }
    all.flip
    return all.readAllStr
  }

//////////////////////////////////////////////////////////////////////////
// print html code
//////////////////////////////////////////////////////////////////////////

  ** m is escapes tick '#'
  private Str parse(Str line, Str m)
  {
    for (i := 0; i < line.size; i++)
    {
      c := line[i].toChar
      if (c.isSpace)
      {
        //continue until nonSpace
        continue
      }
      else if (c == m)
      {
        //escape '#' using '##'
        if (i + 1 < line.size && line[i + 1].toChar == m)
        {
          r := " " + removeChar(line, i)
          return getHtmlStr(r)
        }

        //it's fantom code
        return getFantomStr(removeChar(line, i))
      }
      else
      {
        //it's html code
        return getHtmlStr(line)
      }
    }
    return gap
  }

  private Str removeChar(Str old, Int i)
  {
    s := StrBuf()
    s.add(old)
    return s.remove(i).toStr
  }

  private Str getFantomStr(Str line)
  {
    code := codeGap + line
    return code//.replace("@", "m->")
  }

  private Str getHtmlStr(Str line)
  {
    code := Tokenizer.convert(line, podName)
    return gap + Str<|out.writeChars("""|> + code + Str<|\n""")|>
  }
}