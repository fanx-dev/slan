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
    //m->defaultView is typename/method.
    //put into stash in order to uer can overwrite it
    req.stash["_contentType"] = req.uri.ext
    req.stash["_defaultView"] = `$loc.type.name/${loc.method.name}`

    //call
    invoke(loc.type, loc.method, loc.constructorParams, loc.methodParams)
  }

  **
  ** call method.
  **
  private Void invoke(Type type, Method method, Obj[] constructorParams, Obj[] methodParams)
  {
    weblet := type.make(constructorParams)

    //localization
    loc := locale
    if (loc == null)
    {
      weblet->invoke(method.name, methodParams)
      return
    }

    loc.use
    {
      weblet->invoke(method.name, methodParams)
    }
  }

  **
  ** build-in locale
  **
  Locale? locale()
  {
    localeStr := req.headers["Accept-Language"].split(';').first
    localeStr = localeStr.split(',').first
    list := localeStr.split('-')

    lang := list.first.lower
    country := list.last.upper
    locale := "$lang-$country"

    try
      return Locale(locale)
    catch
      return null
  }
}