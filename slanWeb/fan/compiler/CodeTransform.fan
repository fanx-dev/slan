//
// Copyright (c) 2010 Yang Jiandong
// Licensed under Eclipse Public License version 1.0
//
// History:
//   yangjiandong 2010-10-30 - Initial Contribution
//
using web
using compiler

**
** tranform form template to fantom sources string
**
const class CodeTransform
{
  //shift for mutil line string
  private const Str gap := "\n   "
  private const Str codeGap:=gap+Str.spaces(19)
  const Log log:=Pod.of(this).log
  
  Str transform(File file){
    all:= convertTemplate(file)

    s:= "using web
         using slanweb
         const class HtmlTemplet : SlanWeblet{
          Void dump(|->|? lay){
            out:=res.out
            $all
          }}"

    log.debug(s)
    return s
  }
  
  //Tokenize
  private Str convertTemplate(File file){
    all := StrBuf()
    file.in.eachLine{
      all.add(parse(it,"#"))
    }
    return all.toStr
  }
  
  //m is escapes tick '#'
  private Str parse(Str line,Str m){
    for(i:=0;i<line.size;i++){
      c:=line[i].toChar
      if(c.isSpace){//continue until nonSpace
        continue
      }else if(c==m){
        //escape '#' using '##'
        if(i+1<line.size && line[i+1].toChar==m){
          s := StrBuf()
          s.add(line)
          r:=" "+s.remove(i).toStr
          return getHtmlStr(r)
        }
        //it's fantom code
        s := StrBuf()
        s.add(line)
        return codeGap+s.remove(i).toStr
      }else{//it's html code
        return getHtmlStr(line)
      }
    }
    return gap
  }
  
  private Str getHtmlStr(Str line){
    gap+Str<|out.printLine(""" |>+line+Str<| """)|>
  }
}