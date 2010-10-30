//
// Copyright (c) 2010, Yang Jiandong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Yang Jiandong  Creation
//
using util
using web
using webmod
using compiler
//using compilerJs
**
** Compiler for fwt
**
class JsCompiler
{
  static Void render(WebOutStream out,File file,Str:Str env:=["fwt.window.root":"fwt-root"])
  {
    // compile script into js
    Compiler compiler:=compile(file)
    Str js:=compiler.compile.js
    main := compiler.types[0].qname

    out.includeJs(`/pod/sys/sys.js`)
    out.includeJs(`/pod/concurrent/concurrent.js`)
    out.includeJs(`/pod/web/web.js`)
    out.includeJs(`/pod/gfx/gfx.js`)
    out.includeJs(`/pod/dom/dom.js`)
    out.includeJs(`/pod/fwt/fwt.js`)
    
    out.script.w(js).scriptEnd
    WebUtil.jsMain(out, main,env)
  }

  static Compiler compile(File file)
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