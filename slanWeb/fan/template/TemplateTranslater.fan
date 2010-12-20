//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

using web
using compiler
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

  private const SlanApp slanApp

  new make(SlanApp slanApp)
  {
    this.slanApp = slanApp
  }

  Str translate(File file)
  {
    all := convertTemplate(file)

    s := "using $slanApp.podName
          using web
          using slanWeb

          const class HtmlTemplet : ${SlanWeblet#.name}
          {
            Void dump(|->|? lay, WebOutStream? out_)
            {
              out := out_ ?: res.out
              $all
            }
          }"

    log.debug(s)
    return s
  }

  ** Tokenize
  private Str convertTemplate(File file)
  {
    all := StrBuf()
    file.in.eachLine
    {
      line := this.replace(it, "@", 0)
      all.add(parse(line,"#"))
    }
    return all.toStr
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
        return codeGap + removeChar(line, i)
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

  private Str getHtmlStr(Str line)
  {
    //TODO
    gap + Str<|out.printLine("""|> + line + Str<| """)|>
  }

//////////////////////////////////////////////////////////////////////////
// replace $@message to ${m->message}
//////////////////////////////////////////////////////////////////////////

  private Str replace(Str line, Str m, Int position)
  {
    //echo(line)//?
    for (i := position; i < line.size; i++)
    {
      c := line[i].toChar
      if (c == m && i + 1 < line.size)
      {
        //escape by @@
        if (line[i + 1].toChar == m)
        {
          nline := removeChar(line, i)
          return replace(nline, m, i+1)
        }

        //following is space
        if (line[i + 1].isSpace) continue

        //previous
        if (i - 1 > 0)
        {
          prev := line[i - 1].toChar
          if(prev.isAlphaNum()) continue

          //$@name => ${m->name}
          if (prev == "\$")
          {
            end := endPosition(line, i+1)
            nline := replateStr(line, i..end) { "{m->${it[1..-1]}}" }
            return replace(nline, m, end)
          }

          //Localization
          //$<@name> => $<pod::name>
          if(i-2 > 0 && line[i-2..i-1] == "\$<")
          {
            nline := replateStr(line, i..-2) { "${slanApp.realPodName}::${it[1..-1]}" }
            return replace(nline, m, i+1)
          }
        }

        //@name => m->name
        end := endPosition(line, i+1)
        nline := replateStr(line, i..end) { "m->${it[1..-1]}" }
        return replace(nline, m, end)
      }
    }
    return line
  }

  ** Range r ~ [start..end]
  private Str replateStr(Str oldStr, Range r, |Str->Str| f)
  {
    //echo("$oldStr,$r")//?
    return oldStr[0..<r.start] + f(oldStr[r.start..r.end]) + oldStr[r.end+1..-1]
  }

  private Int endPosition(Str line, Int i)
  {
    while (i < line.size)
    {
      c := line[i].toChar
      if (c.isAlphaNum() || c == "_")
      {
        ++i
        continue
      }
      else{ return i - 1 }
    }
    return line.size -1
  }
}