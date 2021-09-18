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
    depends := Str[,]
    map := Str:Int[:]
    if (this.podName != null) addDepends(this.podName, depends, map)
    this.jsDepends = depends
  }

  private Void addDepends(Str podName, Str[] list, [Str:Int] map) {
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

  Void render(WebOutStream out, File file, [Str:Str]? env := null)
  {
    Str? js
    Str? pod_name
    Str[]? pod_depends
    Str? pod_main
    try {
      [Str:Obj] options = [:]
      //if (file.ext == "fwt") options["compiler"] = "fan"
      js = Env.cur.compileScriptToJs(file, options)
      pod_name = options["pod_name"]
      pod_depends = options["pod_depends"]
      pod_main = options["pod_main"]
    }
    catch (CompilerErr e)
    {
      throw SlanCompilerErr(e, file.readAllStr, file.toStr)
    }
    //echo("$script.depends")

    depends := jsDepends.dup
    map := Str:Int[:]
    depends.each { map[it] = 1 }
    pod_depends.each |c| {
      addDepends(c, depends, map)
    }

    includeAllJs(out, depends)
    
    out.script.w(js).scriptEnd

    if (env == null) env = [:]
    if (!env.containsKey("main")) env["main"] = pod_main
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
