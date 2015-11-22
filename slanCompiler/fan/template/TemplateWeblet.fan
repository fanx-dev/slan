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
mixin TemplateWeblet
{

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
  static Void render(Uri? view := null, |->|? lay := null, WebOutStream? out := null)
  {
    TemplateCompiler template := req.stash.getOrThrow("templateCompiler")
    template.renderUri(view, lay, out)
  }

//////////////////////////////////////////////////////////////////////////
// tools
//////////////////////////////////////////////////////////////////////////

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
const class ReqStash : TemplateWeblet
{
  ** call req.stash[name]
  override Obj? trap(Str name, Obj?[]? args := null)
  {
    if (args == null || args.size == 0)
    {
      if (!req.stash.containsKey(name)) throw ArgErr("not find arg $name")
      return req.stash.get(name)
    }

    if (args.size == 1) { req.stash.set(name, args.first); return this }
    return super.trap(name, args)
  }

  Bool has(Str name)
  {
    return req.stash.containsKey(name)
  }
}