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
internal const class ActionRunner : SlanWeblet
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
    onInvoke(loc.type, loc.method, loc.constructorParams, loc.methodParams)
  }

  **
  ** call method.
  **
  private Void onInvoke(Type type, Method method, Obj[] constructorParams, Obj[] methodParams)
  {
    obj := type.make(constructorParams)
    method.callOn(obj, methodParams)

    //if not committed to default
    if (!res.isCommitted)
    {
      renderDefaultView()
    }
  }

  private Void renderDefaultView()
  {
    if (req.stash["_defaultView"] != null)
    {
      writeContentType(req.stash["_contentType"] as Str)
      this.render((Uri)req.stash["_defaultView"])
    }
  }
}