//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

using compiler
using concurrent
using web

**
** Execute the action.
** m->defaultView is typename/method.html
**
internal const class ActionRunner : Weblet
{
  **
  ** call method.
  **
  Void execute(ActionLocation loc)
  {
    //m->defaultView is typename/method.html.
    //put into stash in order to uer can overwrite it
    ext := req.uri.ext ?: "html"
    req.stash["_contentType"] = ext
    req.stash["_defaultView"] = `$loc.type.name/${loc.method.name}.$ext`

    //call
    invoke(loc.type, loc.method, loc.constructorParams, loc.methodParams)
  }

  **
  ** call method.
  **
  private Void invoke(Type type, Method method, Obj[] constructorParams, Obj[] methodParams)
  {
    SlanWeblet weblet := type.make(constructorParams)
    try
    {
      weblet.before
      method.callOn(weblet, methodParams)
      weblet.after
      //if not committed to default
      if (!res.isCommitted){ renderDefaultView(weblet) }
    }
    catch(Err e)
    {
      throw Err("Action error : name $type.name#$method.name,
                  on $constructorParams,with $methodParams", e)
    }
    finally
    {
      weblet.finall
    }
  }

  private Void renderDefaultView(SlanWeblet weblet)
  {
    if (req.stash["_defaultView"] != null)
    {
      weblet.writeContentType(req.stash["_contentType"] as Str)
      weblet.render((Uri)req.stash["_defaultView"])
    }
  }
}