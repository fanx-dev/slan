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
  private const Str[] jsDepends
  private const Str? podName

  new make(Str? podName := null)
  {
    this.podName = podName
    if (podName != null) {
      depends := Pod.orderByDepends(Pod.flattenDepends([Pod.find(podName)]))
      this.jsDepends = depends.findAll |pod| {
        pod.file(`/${pod.name}.js`, false) != null
      }.map { it.name }
    }
    else
      this.jsDepends = [,]
  }

  Void render(WebOutStream out, File file, [Str:Str]? env := null)
  {
    Str? js
    pod_name := podName ?: file.basename
    try {
      [Str:Obj] options = ["podName" : pod_name]
      if (file.ext == "fwt") options["compiler"] = "fan"
      js = Env.cur.compileScriptToJs(file, options)
    }
    catch (CompilerErr e)
    {
      throw SlanCompilerErr(e, file.readAllStr, file.toStr)
    }
    //echo("$script.depends")

    includeAllJs(out, jsDepends)
    
    out.script.w(js).scriptEnd

    if (env == null) env = [:]
    if (!env.containsKey("main")) env["main"] = "${pod_name}::$file.basename"
    out.initJs(env)
  }

  Void renderByType(WebOutStream out, Str qname, [Str:Str]? env := null)
  {
    includeAllJs(out, jsDepends)
    nenv := ["main":qname]
    if (env != null) nenv.setAll(env)
    out.initJs(nenv)
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
