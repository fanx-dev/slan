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
  protected const SlanApp slanApp
  private const ScriptCache cache := ScriptCache()

  new make(SlanApp slanApp)
  {
    this.slanApp = slanApp
  }

  Void render(WebOutStream out, File file, [Str:Str]? env := null)
  {
    script := getJsScript(file)

    includeAllJs(out, slanApp.depends, slanApp.realPodName)
    out.script.w(script.js).scriptEnd
    WebUtil.jsMain(out, script.main, env)
  }

  Void renderByType(WebOutStream out, Str qname, [Str:Str]? env := null)
  {
    includeAllJs(out, slanApp.depends, slanApp.realPodName)
    WebUtil.jsMain(out, qname, env)
  }

//////////////////////////////////////////////////////////////////////////
// include js
//////////////////////////////////////////////////////////////////////////

  private Void includeJs(WebOutStream out, Str podName)
  {
    out.includeJs(`/pod/$podName/${podName}.js`)
  }

  private Void includeAllJs(WebOutStream out, Str[] usings, Str curPod)
  {
    //add system class path
    out.includeJs(`/pod/sys/sys.js`)
    out.includeJs(`/pod/concurrent/concurrent.js`)
    out.includeJs(`/pod/web/web.js`)
    out.includeJs(`/pod/gfx/gfx.js`)
    out.includeJs(`/pod/dom/dom.js`)
    out.includeJs(`/pod/fwt/fwt.js`)
    out.includeJs(`/pod/fwt/fwt.js`)

    //add user's class path
    usings.each
    {
      includeJs(out, it)
    }
    includeJs(out, curPod)
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