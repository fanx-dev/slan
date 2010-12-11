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
mixin SlanWeblet
{
  **
  ** current slanApp
  **
  SlanApp slanApp() { Actor.locals[ActionMod.slanAppId] }

//////////////////////////////////////////////////////////////////////////
// Request/Response
//////////////////////////////////////////////////////////////////////////

  **
  ** The WebReq instance for this current web request.  Raise an exception
  ** if the current actor thread is not serving a web request.
  **
  static WebReq req()
  {
    try
      return Actor.locals["web.req"]
    catch (NullErr e)
      throw Err("No web request active in thread")
  }

  **
  ** The WebRes instance for this current web request.  Raise an exception
  ** if the current actor thread is not serving a web request.
  **
  static WebRes res()
  {
    try
      return Actor.locals["web.res"]
    catch (NullErr e)
      throw Err("No web request active in thread")
  }

//////////////////////////////////////////////////////////////////////////
// template method
//////////////////////////////////////////////////////////////////////////

  **
  ** render the template
  **
  Void render(Uri html, |->|? lay := null)
  {
    file := slanApp.resourceHelper.getUri(`res/view/` + html).get
    slanApp.templateCompiler.render(file, lay)
  }

  **
  ** compile js file.
  **
  Str compileJs(Uri fwt, Str:Str env := ["fwt.window.root":"fwt-root"])
  {
    file := slanApp.resourceHelper.getUri(`res/fwt/` + fwt).get
    strBuf := StrBuf()
    slanApp.jsCompiler.render(WebOutStream(strBuf.out), file, env)
    return strBuf.toStr
  }

//////////////////////////////////////////////////////////////////////////
// tools
//////////////////////////////////////////////////////////////////////////

  **
  ** default is 'text/html; charset=utf-8'
  **
  Void writeContentType(Str? ext := null)
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
  ** go back to referer uri
  **
  Void goback()
  {
    Str uri := req.headers["Referer"]
    res.redirect(uri.toUri)
  }

  **
  ** convert method to uri
  **
  Uri getUri(Type type, Method? method := null, Str? id := null)
  {
    uri := "/action/$type.name"
    if (method != null)
    {
      uri += "/$method.name"
    }
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

  **
  ** escaped xml control characters
  **
  Str? h(Obj? obj)
  {
    if (obj == null) return null
    return obj.toStr.toXml
  }

  **
  ** req.stash[]
  **
  const static ReqStash m := ReqStash()
}


**************************************************************************
** ReqStash pass data from controller to view
**************************************************************************

**
** wrap for req.stash
**
const class ReqStash : SlanWeblet
{
  ** call req.stash[name]
  override Obj? trap(Str name, Obj?[]? args)
  {
    if (args.size == 0)
    {
      if (!req.stash.containsKey(name)) throw ArgErr("not find arg $name")
      return req.stash.get(name)
    }

    if (args.size == 1) { req.stash.set(name, args.first); return null }
    return super.trap(name, args)
  }
}