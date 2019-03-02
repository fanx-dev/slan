//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

using webmod
using web
using concurrent
using slanCompiler

**
** Route for all Mod
**
const class ScriptMod : WebMod
{
  private const Uri errorPage := `/error.html`

  ** res path
  const File dir

  ** main pod
  const Pod? pod


  const ScriptCompiler scriptCompiler
  **
  ** fantom to javascript compiler
  **
  const JsCompiler jsCompiler

  **
  ** html template to fantome class compiler
  **
  const TemplateCompiler templateCompiler


  **
  ** depends javascript pod names
  **
  private Void addJsDepends(Str[] depends, Pod pod)
  {
    pod.depends.each
    {
      p := Pod.find(it.name)
      addJsDepends(depends, p)
    }

    if (pod.file(`/${pod.name}.js`, false) != null)
    {
      if (!depends.contains(pod.name)) depends.add(pod.name)
    }
  }

  new make(File? appPath, Str? podName)
  {
    this.dir = appPath

    if (podName == null && appPath == null) {
      throw ArgErr("require podName or appPath")
    }

    if (appPath != null) {
      if (!appPath.isDir)  throw ArgErr("Invalid appHome:$appPath Directory need a slash")
    }

    jsDepends := Str[,]
    if (podName != null) {
      pod = Pod.find(podName)
      addJsDepends(jsDepends, pod)
    }

    jsCompiler = JsCompiler(jsDepends, podName)
    templateCompiler = TemplateCompiler(podName)
    scriptCompiler = ScriptCompiler(podName)
  }

  override Void onService() {
    try {
      doService
    }
    catch (Err err) {
      err.trace
      onErro(err)
    }
  }

  **
  ** res path. switch podFile or file
  **
  File? findFile(Uri path, Bool checked := false)
  {
    f := dir.plus(path)
    if (f.exists) return f

    if (pod != null) {
      File? pf = pod.file(`/$path`, false)
      if (pf != null) return pf
    }

    if (checked) {
      throw ArgErr("File not found $f")
    }
    return null
  }

  private Void doService()
  {
    req.modBase = `/`
    //echo("modBase:$req.modBase modRel:$req.modRel")

    if (req.modRel.toStr.contains("..")) {
      res.sendErr(400); return
    }

    resolver := ScriptResolver(this, req.modRel.path)
    file := resolver.findScript

    //echo("ScriptMod: $file ${req.modRel.path}")
    if (file == null) {
      return
    }

    switch (file.ext) {
      case "fan":
        reanderScript(file, resolver.modBase)
        res.done
      case "fwt":
        renderFwt(file)
        res.done
      case "fsp":
        renderTemplate(file)
        res.done
      default:
        return
    }
  }

  private Void initCompiler() {
    req.stash["_templateCompiler"] = templateCompiler
    req.stash["_jsCompiler"] = jsCompiler
    req.stash["_resResolver"] = |Uri uri->File| { findFile(uri, true) }
  }

  private Void reanderScript(File file, Uri? modBase) {
    Str? mime
    if (req.modRel.ext != null) {
      mime = MimeType.forExt(req.modRel.ext)?.toStr
    }
    res.headers["Content-Type"] = mime ?: "text/plain; charset=utf-8"

    type := scriptCompiler.getType(file)
    Weblet obj := type.make()
    if (modBase != null) {
      //echo("deepin: $modBase")
      req.modBase = `/$modBase/`
    }

    initCompiler
    obj.onService
  }

  private Void renderFwt(File file) {
    res.headers["Content-Type"] = "text/html; charset=utf-8"
    out := res.out
    out.docType
    out.html
    out.head
      out.title.w("$file.name").titleEnd
      
      jsCompiler.render(out, file)

    out.headEnd
    out.body
    out.bodyEnd
    out.htmlEnd
  }

  private Void renderTemplate(File file) {
    res.headers["Content-Type"] = "text/html; charset=utf-8"

    initCompiler
    templateCompiler.render(file)
  }

//////////////////////////////////////////////////////////////////////////
// error
//////////////////////////////////////////////////////////////////////////

  ** trace errInfo
  private Void onErro(Err err)
  {
    if (req.absUri.host == "localhost")
    {
      //show error on debug mode
      showErr(err)
    }
    else if (req.uri.relToAuth == errorPage)
    {
      //error page not found
      msg := "sorry! don't find error page $errorPage .by slanweb"
      if (!res.isCommitted)
        res.sendErr(500, msg)
      else
        res.out.w(msg)
    }
    else
    {
      //to error page
      this.res.redirect(errorPage)
    }
    res.done
  }

  private Void showErr(Err err)
  {
    if (res.isCommitted && !res.isDone)
    {
      //err.trace
      res.out.print("<p>ERROR: $req.uri</p>")
      res.out.w(err.traceToStr.replace("\n","<br/>"))
    }
    else if (err is SlanCompilerErr)
    {
      res.statusCode = 500
      res.headers.clear
      res.headers["Content-Type"] = "text/html; charset=utf-8"
      res.out.print(err->dump)
    }
  }
}

internal class ScriptResolver {
  Str[] paths
  Int pos := 0
  Uri file
  Uri? modBase

  ScriptMod mod

  new make(ScriptMod mod, Str[] paths) {
    this.mod = mod
    this.paths = paths
    file = ``
  }

  private Bool cosume() {
    if (pos < paths.size) {
      file = file.plusName(paths[pos])
      modBase = file
      ++pos
      return true
    }
    else if (pos == paths.size) {
      file = file.plusName("Index")
      ++pos
      return true
    }
    return false
  }

  File? findScript() {
    while (cosume) {
      //echo("ScriptResolver: $file")
      //find script
      s := mod.findFile(`${file}.fan`)
      if (s != null) return s

      File? f
      try {
        f = mod.findFile(file)
      }
      catch {
        file = file.plusSlash
        f = mod.findFile(file)
      }

      if (f != null) {
        if (f.isDir) continue
        return f
      }
      return null      
    }
    return null
  }
}
