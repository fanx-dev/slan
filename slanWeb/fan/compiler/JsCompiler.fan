//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

using util
using web
using webmod
using compiler

**
** fantome to javascript Compiler for fwt
**
const class JsCompiler
{
  private const ScriptCache cache := ScriptCache()

  private const Str[] jsDepends
  private const Str? podName

  new make(Str[] jsDepends, Str? podName := null)
  {
    this.jsDepends = jsDepends
    this.podName = podName
  }

  Void render(WebOutStream out, File file, [Str:Str]? env := null)
  {
    script := getJsScript(file)

    includeAllJs(out, jsDepends, podName)
    out.script.w(script.js).scriptEnd
    WebUtil.jsMain(out, script.main, env)
  }

  Void renderByType(WebOutStream out, Str qname, [Str:Str]? env := null)
  {
    includeAllJs(out, jsDepends, podName)
    WebUtil.jsMain(out, qname, env)
  }

//////////////////////////////////////////////////////////////////////////
// include js
//////////////////////////////////////////////////////////////////////////

  private Void includeJs(WebOutStream out, Str podName)
  {
    out.includeJs(`/pod/$podName/${podName}.js`)
  }

  private Void includeAllJs(WebOutStream out, Str[] usings, Str? curPod)
  {
    usings.each
    {
      includeJs(out, it)
    }
    if (curPod != null) includeJs(out, curPod)
  }

//////////////////////////////////////////////////////////////////////////
// compile js
//////////////////////////////////////////////////////////////////////////

  **
  ** compile to jscode
  **
  JsScript getJsScript(File file)
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

  ** compile script into js
  private JsScript compile(Str source, File file)
  {
    Compiler compiler := getCompile(source, file)
    Str js := compiler.compile.js
    main := compiler.types[0].qname
    return JsScript
    {
      it.js = js;
      it.main = main
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

    return Compiler(input)
  }
}

**************************************************************************
** JsScript
**************************************************************************

const class JsScript
{
  const Str js;
  const Str main;

  new make(|This| f)
  {
    f(this)
  }
}