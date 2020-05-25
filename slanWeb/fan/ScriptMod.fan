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
  const File? dir

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

  new make(File? appPath, Str? podName)
  {
    this.dir = appPath

    if (podName == null && appPath == null) {
      throw ArgErr("require podName or appPath")
    }

    if (appPath != null) {
      if (!appPath.isDir)  throw ArgErr("Invalid appHome:$appPath Directory need a slash")
    }

    if (podName != null) {
      pod = Pod.find(podName)
    }

    jsCompiler = JsCompiler(podName)
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
    File? base
    if (dir != null) {
      rpath := path
      if (!path.isPathAbs) {
        base = dir + req.modBase.relTo(`/`)
      }
      else {
        base = dir
        rpath = path.relTo(`/`)
      }
      f := base.plus(rpath, false)
      if (f.exists) return f
    }

    if (pod != null && path.isPathAbs) {
      uri := path
      File? pf = pod.file(uri, false)
      //echo("$pod $uri $pf")
      if (pf != null) return pf
    }

    if (checked) {
      throw ArgErr("File not found $path in file:$base or pod:$pod")
    }
    return null
  }

  private Void doService()
  {
    req.modBase = `/`
    //echo("modBase:$req.modBase modRel:$req.modRel")

    modRel := req.modRel
    if (modRel.toStr.contains("..")) {
      res.sendErr(400); return
    }

    //find script file
    paths := modRel.path
    resolver := ScriptResolver(this, paths)
    file := resolver.findScript

    //try as Dir
    if (file == null) {
      file = findFile(modRel)
    }

    //try find in pod class
    if (file == null && pod != null) {
      name := paths.first ?: "Index"
      type := pod.type(name, false)
      if (type != null) {
        reanderType(type)
        res.done
        return
      }
    }

    //not found
    if (file == null) {
      echo("file not found: $req.modRel")
      res.sendErr(404)
      return
    }

    //deep into dir
    if (resolver.modBase != null && resolver.modBase.isDir) {
      req.modBase = `/$resolver.modBase`
    }

    extName := file.ext ?: ""
    
    if (extName == "fan" && dir != null) {
      //.fwt no IDE support, temp fix
      fp := file.uri.relTo(dir.uri).path
      if (fp.first == "view") {
        extName = "fwt"
      }
    }

    switch (extName) {
      case "fan":
        reanderScript(file)
        res.done
      case "fwt":
        renderFwt(file)
        res.done
      case "fsp":
        renderTemplate(file)
        res.done
      default:
        renderStaticFile(file)
        res.done
        return
    }
  }

  private Void initCompiler() {
    req.stash["_templateCompiler"] = templateCompiler
    req.stash["_jsCompiler"] = jsCompiler
    req.stash["_resResolver"] = |Uri uri->File| { findFile(uri, true) }
  }

  private Void setContentType() {
    Str? mime
    if (req.modRel.ext != null) {
      mime = MimeType.forExt(req.modRel.ext)?.toStr
    }
    res.headers["Content-Type"] = mime ?: "text/plain; charset=utf-8"
  }

  private Void reanderScript(File file) {
    setContentType

    type := scriptCompiler.getType(file)
    Weblet obj := type.make()

    initCompiler
    obj.onService
  }

  private Void reanderType(Type type) {
    if (type.hasFacet(sys::Js#)) {
      res.headers["Content-Type"] = "text/html; charset=utf-8"
      out := res.out
      out.docType
      out.html
      out.head
        out.title.w("$type.name").titleEnd
        out.w("""<meta name="viewport" content="width=device-width, initial-scale=1.0">\n""")
        
        jsCompiler.renderByType(out, type.qname)

      out.headEnd
      out.body
      out.bodyEnd
      out.htmlEnd
    }
    else {
      setContentType

      Weblet obj := type.make()
      //echo("reanderType: $type, $modBase ${req.modRel.path}")

      initCompiler
      obj.onService
    }
  }

  private Void renderFwt(File file) {
    res.headers["Content-Type"] = "text/html; charset=utf-8"
    out := res.out
    out.docType
    out.html
    out.head
      out.title.w("$file.name").titleEnd

      out.w("""<meta name="viewport" content="width=device-width, initial-scale=1.0">\n""")
      
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

  private Void renderStaticFile(File f)
  {
    // if we've resolved a directory
    if (f.isDir)
    {
      // if trailing slash wasn't used by req, redirect to use slash
      if (!req.uri.isDir) { res.redirect(req.uri.plusSlash); return }

      // map to "index.html"
      index := f + `index.html`
      if (!index.exists) {
        renderDir(f)
        return
      }
      else {
        f = index
      }
    }

    // publish the file
    FileWeblet(f).onService
  }

  private Void renderDir(File f) {
    res.statusCode = 200
    res.headers["Content-Type"] = "text/html; charset=utf-8"
    out := res.out
    out.head
      .title.w("$f.name").titleEnd
    out.headEnd
    out.body
      .w("<a href='/'>Index</a>")
      .h1.w("$req.modRel").h1End

    f.list.findAll { !it.name.startsWith(".") }
    .sort |f1,f2|{ f1.name <=> f2.name }
    .each {
      name := it.name
      date := DateTime.fromTimePoint(it.modified).toLocale("YYYY-MM-DD hh:mm:ss")
      if (it.isDir) { name += "/" }
      out.p
        .w("<a href='$name'>$name</a>")
        .w(" $date")
      .pEnd
    }

    out.hr
    out.bodyEnd.htmlEnd
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
  //paths to deal with
  private Str[] paths
  //cur position
  private Int pos := 0
  //already found dir
  private Uri file := ``
  Uri? modBase

  ScriptMod mod

  new make(ScriptMod mod, Str[] paths) {
    this.mod = mod
    this.paths = paths
  }

  private Bool cosume() {
    if (pos < paths.size) {
      modBase = file
      file = file.plusName(paths[pos])
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

      File? f := mod.findFile(file)
      if (f != null) {
        if (f.isDir) {
          file = file.plusSlash
          continue
        }
        return f
      }
      return null
    }
    return null
  }
}
