
using web

**
** FileMod is a web module which publishes a file or directory.
**
** See [pod doc]`pod-doc#file`
**
const class SFileMod : WebMod
{
  **
  ** Constructor with it-block, must set `file`
  **
  new make(|This|? f) { f?.call(this) }

  **
  ** File or directory to publish.  This field must be
  ** configured in the constructor's it-block.
  **
  const File file

  override Void onService()
  {
    // if servicing a single file, we handle specially
    if (!file.isDir)
    {
      // don't publish a single file with path longer than mod itself
      if (!req.modRel.path.isEmpty) { res.sendErr(404); return }

      // publish the file and we ar don
      FileWeblet(file).onService
      return
    }

    // get file under directory
    rel := req.uri.relTo(req.modBase)

    //echo("SFile: $rel")

    relStr := rel.toStr
    if (relStr.startsWith("/") || relStr.contains("..")) {
      res.sendErr(404); return
    }

    f := this.file.plus(rel, false)
    //echo("$rel, $f")
    //echo("$req.uri = $req.modBase + $req.modRel")

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

    // if it doesn't exist then 404
    if (!f.exists) { res.sendErr(404); return }

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

}