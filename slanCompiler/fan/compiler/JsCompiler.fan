//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

//using util
using web
//using webmod
using compiler

**
** fantome to javascript Compiler for fwt
**
const class JsCompiler
{
  private const ScriptCache cache := ScriptCache()

  private const Str[] jsDepends
  private const Str? podName

  new make(Str? podName := null)
  {
    this.podName = podName
    depends := Str[,]
    map := Str:Int[:]
    if (this.podName != null) addDepends(this.podName, depends, map)

    this.jsDepends = depends
  }

  Void render(WebOutStream out, File file, [Str:Str]? env := null)
  {
    script := getJsScript(file)
    //echo("$script.depends")

    includeAllJs(out, script.depends)
    
    out.script.w(script.js).scriptEnd
    WebUtil.jsMain(out, script.main, env)
  }

  Void renderByType(WebOutStream out, Str qname, [Str:Str]? env := null)
  {
    includeAllJs(out, jsDepends)
    WebUtil.jsMain(out, qname, env)
  }

//////////////////////////////////////////////////////////////////////////
// include js
//////////////////////////////////////////////////////////////////////////

  private Void includeAllJs(WebOutStream out, Str[] usings)
  {
    domkit := false
    usings.each |podName|
    {
      out.includeJs(`/pod/$podName/${podName}.js`)
      if (podName == "domkit") domkit = true
    }
    if (domkit) out.includeCss(`/pod/domkit/res/css/domkit.css`)
  }

//////////////////////////////////////////////////////////////////////////
// compile js
//////////////////////////////////////////////////////////////////////////

  **
  ** compile to jscode
  **
  internal JsScript getJsScript(File file)
  {
    cache.getOrAdd(file)|->Obj|
    {
      source := file.readAllStr
      try
      {
        return compile(source, file)
      }
      catch (CompilerErr e)
      {
        throw SlanCompilerErr(e, source, file.toStr)
      }
    }
  }

  Void clearCache()
  {
    cache.clear
  }

  private Void addDepends(Str podName, Str[] list, Str:Int map) {
    if (!map.containsKey(podName)) {
      map[podName] = 1
    } else {
      return
    }

    pod := Pod.find(podName)
    pod.depends.each |c| {
      addDepends(c.name, list, map)
    }

    if (pod.file(`/${pod.name}.js`, false) != null) {
      list.add(podName)
    }
  }

  ** compile script into js
  private JsScript compile(Str source, File file)
  {
    Compiler compiler := getCompile(source, file)
    Str js := compiler.compile.js
    main := compiler.types[0].qname


    depends := jsDepends.dup
    map := Str:Int[:]
    depends.each { map[it] = 1 }
    compiler.depends.each |c| {
      addDepends(c.name, depends, map)
    }

    return JsScript {
      it.js = js;
      it.main = main
      it.depends = depends
    }
  }

  private Compiler getCompile(Str source, File file)
  {
    input := CompilerInput.make
    input.podName   = file.basename
    input.summary   = "fwt"
    input.version   = Version("0")
    input.log.level = LogLevel.err
    input.isScript  = true
    input.srcStr    = source
    input.srcStrLoc = Loc.makeFile(file)
    input.mode      = CompilerInputMode.str
    input.output    = CompilerOutputMode.js
    input.depends   = [Depend("sys 2.0"), Depend("std 1.0")]

    return Compiler(input)
  }
}

**************************************************************************
** JsScript
**************************************************************************

internal const class JsScript
{
  const Str js;
  const Str main;
  const Str[] depends;

  new make(|This| f)
  {
    f(this)
  }
}