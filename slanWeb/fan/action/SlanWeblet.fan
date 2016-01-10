//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

using web
using concurrent

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
    req.stash["_defaultView"] = `$typeof.name/$method.name`
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
    Str[]? paths := req.stash["_paths"]
    Method? method
    hasSubPath := false
    if (paths != null && paths.first != null) {
      method = this.typeof.method(paths.first, false)
      hasSubPath = true

      if (method != null) {
        if (paths != null && paths.size > 1) {
          req.stash["_stashId"] = paths[1]
        }
        return method
      }
    }

    //named op
    if (paths != null) {
      req.stash["_stashId"] = paths.first
    }

    if (!hasSubPath && req.method == "GET") {
      method = this.typeof.method("index", false)
      if (method != null) {
        return method
      }
    }

    method = this.typeof.method(req.method.lower, false)

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

  **
  ** render the template
  **
  virtual Void render(Uri? view := null, |->|? lay := null)
  {
    if (view == null)
    {
      renderDefaultView
      return
    }

    //writeContentType
    ext := (req.modRel.ext) ?: "html"
    if (!res.isCommitted) setContentType(ext)

    slanApp := SlanApp.cur
    req.stash["templateCompiler"] = slanApp.templateCompiler

    if (view.ext == null) {
      view = `${view}.$ext`
    }
    slanApp.templateCompiler.renderUri(view, lay)
  }

  ** render default view
  private Void renderDefaultView()
  {
    view := req.stash["_defaultView"]
    // this condition prevent from endless loop
    if (view != null)
      render((Uri)view)
    else
      throw Err("Not find defaultView")
  }

  **
  ** compile js file.
  **
  Str compileJs(Uri fwt, Str:Str env := ["fwt.window.root":"fwt-root"])
  {
    slanApp := SlanApp.cur
    file := slanApp.getResUri(`res/fwt/` + fwt).get
    buf := Buf()
    slanApp.jsCompiler.renderFile(WebOutStream(buf.out), file, env)
    buf.flip
    return buf.readAllStr
  }

//////////////////////////////////////////////////////////////////////////
// tools
//////////////////////////////////////////////////////////////////////////

  **
  ** default is 'text/html; charset=utf-8'
  **
  Void setContentType(Str? ext := null)
  {
    if (ext == null)
    {
      res.headers["Content-Type"] = "text/plain; charset=utf-8"
    }
    else
    {
      res.headers["Content-Type"] = MimeType.forExt(ext).toStr
    }
  }

  **
  ** convert method to uri
  **
  Uri toUri(Method method, Obj? id := null)
  {
    uri := "/action/$method.parent.name/$method.name"
    if (id != null)
    {
      uri += "/$id"
    }
    return uri.toUri
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
      res.headers["Content-Type"] = "text/plain; charset=utf-8"

      WebOutStream out := req.stash["_out"] ?: res.out
      if(result.typeof.hasFacet(Serializable#))
        out.writeObj(result)
      else
        out.w(result)
    }
  }

}

