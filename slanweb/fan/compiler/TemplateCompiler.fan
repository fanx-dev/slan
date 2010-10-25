//
// Copyright (c) 2010, Yang Jiandong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Yang Jiandong  Creation
//

using web
using compiler


const class TemplateCompiler
{
  //shift for mutil line string
  private const Str gap := "\n   "
  private const Cache cache:=Cache()
  const Log log:=Pod.of(this).log
  
  static const TemplateCompiler instance:=TemplateCompiler()
  

  private new make(){}

  Void render(File file,|->|? lay:=null)
  {
    type:=getType(file)
    obj:=type.make
    type.method("dump").call(obj,lay)
  }
  
  ** from cache or compile
  Type getType(File file){
    key:=file.toStr
    Type? type
    cacheScript:=getCache(key,file)
    if(cacheScript!==null){
      type= Type.find(cacheScript.typeName, false)
    }

    if(type==null){
      type=compile(file.in)
      putCache(key,Script{
          modified=file.modified;
          size=file.size;
          typeName=type.qname
        })
    }
    return type
  }

  private Script? getCache(Str key,File file){
    Script? c:= cache[key]
    if(c==null)return null
    if(!c.eq(file)){
      cache.remove(key)
      return null
    }
    return c
  }

  private Void putCache(Str key,Script script){
    cache[key]=script
  }

//////////////////////////////////////////////////////////////////////////
// compile
//////////////////////////////////////////////////////////////////////////

  private Type compile(InStream in){
    all := StrBuf()
    in.eachLine{
      parse(it,"#",all)
    }

    s:= "using web
         using slanweb
         const class HtmlTemplet : SlanWeblet{
          Void dump(|->|? lay){
            out:=res.out
            $all.toStr
          }}"

    log.debug(s)
    pod:=compileScript("fsp_pod_$DateTime.nowUnique",s)
    type:=pod.type("HtmlTemplet")
    return type
  }

  //m is escapes tick
  private Void parse(Str line,Str m,StrBuf all){
    for(i:=0;i<line.size;i++){
      c:=line[i].toChar
      if(c.isSpace){//continue until nonSpace
        continue
      }else if(c==m){
        //escape m
        if(i+1<line.size && line[i+1].toChar==m){
          s := StrBuf()
          s.add(line)
          r:=s.remove(i).toStr
          all.add(gap+Str<|out.printLine(""" |>+r+Str<| """)|>)
          return
        }
        //it's fantom code
        s := StrBuf()
        s.add(line)
        all.add(gap+"              "+
            s.remove(i).toStr)
        return
      }else{//it's html code
        all.add(gap+Str<|out.printLine(""" |>+line+Str<| """)|>)
        return
      }
    }
  }

  //compileFantomScript
  private Pod compileScript(Str podName, Str source)
  {
    input := CompilerInput
    {
      it.podName  = podName
      summary     = "fsp"
      isScript    = true
      version     = Version.defVal
      it.log.level   = LogLevel.warn
      output      = CompilerOutputMode.transientPod
      mode        = CompilerInputMode.str
      srcStr      = source
      srcStrLoc   = Loc("fsp")
    }

    return Compiler(input).compile.transientPod
  }
}

**************************************************************************
** Script Cache Object
**************************************************************************

const class Script{

  const DateTime modified;
  const Int size;
  const Str? typeName;

  Bool eq(File file){
    if(this.modified!=file.modified)return false
    if(this.size!=file.size)return false
    return true
  }

  new make(|This| f){
    f(this)
  }
}