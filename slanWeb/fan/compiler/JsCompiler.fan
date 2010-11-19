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
** Compiler for fwt
**
class JsCompiler
{
  private static const ScriptCache cache := ScriptCache()

  static Void render(WebOutStream out, File file, Uri[]? usings := null,
    Str:Str env := ["fwt.window.root":"fwt-root"])
  {
    script := getJsScript(file)

    //add system class path
    out.includeJs(`/pod/sys/sys.js`)
    out.includeJs(`/pod/concurrent/concurrent.js`)
    out.includeJs(`/pod/web/web.js`)
    out.includeJs(`/pod/gfx/gfx.js`)
    out.includeJs(`/pod/dom/dom.js`)
    out.includeJs(`/pod/fwt/fwt.js`)

    //add user's class path
    if (usings != null)
    {
      usings.each
      {
        out.includeJs(it)
      }
    }

    out.script.w(script.js).scriptEnd
    WebUtil.jsMain(out, script.main, env)
  }

  ** from cache or compiler
  static JsScript getJsScript(File file)
  {
    cache.getOrAdd(file)|->Obj|
    {
      // compile script into js
      Compiler compiler := compile(file)
      Str js := compiler.compile.js
      main := compiler.types[0].qname
      return JsScript
      {
        it.js = js;
        it.main = main
      }
    }
  }

  private static Compiler compile(File file)
  {
    input := CompilerInput.make
    input.podName   = file.basename
    input.summary   = ""
    input.version   = Version("0")
    input.log.level = LogLevel.err
    input.isScript  = true
    input.srcStr    = file.readAllStr
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