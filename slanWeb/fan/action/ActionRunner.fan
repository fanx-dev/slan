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
    //req.stash["_defaultView"] = `$loc.type.name/${loc.method.name}`

    //call
    result := invoke(loc.type, loc.method, loc.constructorParams, loc.methodParams)
    sendResult(result)
  }

  **
  ** call method.
  **
  private Obj? invoke(Type type, Method method, Obj[] constructorParams, Obj[] methodParams)
  {
    weblet := type.make(constructorParams)

    Obj? result := null

    //localization
    loc := locale
    if (loc != null)
    {
      loc.use
      {
        result = weblet->onInvoke(method.name, methodParams)
      }
    }
    else
    {
      result = weblet->onInvoke(method.name, methodParams)
    }
    return result
  }

  private Void sendResult(Obj? result)
  {
    if (result != null && !res.isCommitted)
    {
      res.headers["Content-Type"] = "text/plain; charset=utf-8"

      if(result.typeof.hasFacet(Serializable#))
        res.out.writeObj(result)
      else
        res.out.w(result)
    }
  }

  **
  ** build-in locale
  **
  private Locale? locale()
  {
    acceptLang := req.headers["Accept-Language"]
    if (acceptLang == null || acceptLang == "") return null

    localeStr := acceptLang.split(';').first
    localeStr = localeStr.split(',').first
    list := localeStr.split('-')

    lang := list.first.lower
    country := list.last.upper
    locale := "$lang-$country"

    return Locale.fromStr(locale, false)
  }
}