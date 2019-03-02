//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

using web
using concurrent
using slanCompiler

**
** enhanced Weblet for rendering template.
**
mixin SlanWeblet : Weblet
{

  override Void onService() {

    method := findMethod();
    if (method == null) {
      res.sendErr(404)
      return
    }

    if (!checkMethod(method)) {
      res.sendErr(405)
      return
    }

    args := ParameterHelper.getParamsByName(req.uri.query, method.params, req.form)
    result := trap(method.name, args)

    if (result != null) {
      sendObj(result)
    }
  }

  **
  ** find method and get methodParams using restPath
  **
  private Method? findMethod()
  {
    Str[] paths := req.modRel.plusName(req.modRel.basename).path

    rel := req.uri.relTo(req.modBase)
    //echo("findMethod: $paths, modRel:${req.modRel} modBase:${req.modBase} uri:${req.uri} rel:${rel}")

    Method? method
    hasSubPath := false
    if (paths.size > 0) {
      method = this.typeof.method(paths.first, false)
      if (method != null) {
        if (paths.size > 1) {
          req.stash["_stashId"] = paths[1]
        }
        return method
      }
      else {
        req.stash["_stashId"] = paths.first
      }
    }

    if (paths.size == 0 && req.method == "GET") {
      method = this.typeof.method("index", false)
      if (method != null) {
        return method
      }
    }

    method = this.typeof.method(req.method.lower, false)
    if (method == null) echo("method not found $paths")
    return method
  }

  private Bool checkMethod(Method m)
  {
    if (!m.isPublic) {
      return false
    }

    Bool allow := false
    switch(req.method)
    {
      case "GET":
        hasGet := m.hasFacet(WebGet#)
        if (hasGet) {
          allow = true
        } else {
          if (m.hasFacet(WebPost#)
              || m.hasFacet(WebDelete#)
              || m.hasFacet(WebHead#)
              || m.hasFacet(WebTrace#)
              || m.hasFacet(WebPut#)) {
            allow = false
          } else {
            allow = true
          }
        }
      case "POST":
        allow = m.hasFacet(WebPost#)
      case "PUT":
        allow = m.hasFacet(WebPut#)
      case "DELETE":
        allow = m.hasFacet(WebDelete#)
      case "HEAD":
        allow = m.hasFacet(WebHead#)
      case "TRACE":
        allow = m.hasFacet(WebTrace#)
      case "OPTIONS":
        allow = m.hasFacet(WebOptions#)
      default:
        allow = false
    }
    return allow
  }

//////////////////////////////////////////////////////////////////////////
// template method
//////////////////////////////////////////////////////////////////////////

  Void setContentType(Str? ext := null) {
    if (ext == null) ext = (req.modRel.ext) ?: "html"
    Str? mime := MimeType.forExt(ext)?.toStr
    res.headers["Content-Type"] = mime ?: "text/plain; charset=utf-8"
  }

  **
  ** render the template
  **
  virtual Void render(Uri view, |->|? lay := null)
  {
    //writeContentType
    ext := (req.modRel.ext) ?: "html"
    if (!res.isCommitted) {
      setContentType(ext)
    }

    if (view.ext == null) {
      view = `${view}.$ext`
    }

    |Uri uri->File| resReserver := req.stash["_resResolver"]
    TemplateCompiler templateCompiler := req.stash["_templateCompiler"]
    templateCompiler.render(resReserver(view), lay)
  }

  **
  ** compile js file.
  **
  Str compileJs(Uri fwt, Str:Str env := ["fwt.window.root":"fwt-root"])
  {
    |Uri uri->File| resReserver := req.stash["_resResolver"]
    JsCompiler jsCompiler := req.stash["_jsCompiler"]

    buf := Buf()
    jsCompiler.render(WebOutStream(buf.out), resReserver(fwt), env)
    buf.flip
    return buf.readAllStr
  }

  **
  ** id is the first word of unnecessary uri
  **
  Str? stashId()
  {
    req.stash["_stashId"]
  }

  ** set param
  Void stash(Str name, Obj? obj) {
    req.stash[name] = obj
  }

  **
  ** escape the xml control characters
  **
  Str? esc(Obj? obj)
  {
    if (obj == null) return null
    return obj.toStr.toXml
  }

  Void sendObj(Obj? result)
  {
    if (result != null && !res.isCommitted)
    {
      if (res.headers["Content-Type"] == null)
        res.headers["Content-Type"] = "text/plain; charset=utf-8"

      WebOutStream out := req.stash["_out"] ?: res.out
      if(result.typeof.hasFacet(Serializable#))
        out.writeObj(result)
      else
        out.w(result)
    }
  }

}

