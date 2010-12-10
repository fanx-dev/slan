//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed.Y  Creation
//

using web

**
** route and find the action.
** find Ctrller#action and fill params
**
internal class ActionLocation : Weblet
{
  private const SlanApp slanApp
  private Uri dir //action directory

  private Str[]? restPath

  Type? type
  Method? method

  Obj?[]? constructorParams
  Obj?[]? methodParams


  new make(SlanApp slanApp, Uri dir)
  {
    this.slanApp = slanApp
    this.dir = dir
  }

  **
  ** mapping uri to action
  **
  Bool parse(Str[] path)
  {
    //this.path = path
    this.restPath = path

    findType
    findConstructor
    findMethod

    if (!checkWebMethod(method)){ res.sendErr(405); return false }

    findMethodParams
    setStashId

    return true
  }

  **
  ** find controller type
  **
  private Void findType()
  {
    name := restPath.first
    if(name == null)
    {
      useIndexCtrl
      return
    }

    type = slanApp.resourceHelper.getType(getTypeName(name), dir, false)
    if (type != null)
    {
      consumeResPath
    }
    else
    {
      useIndexCtrl
    }
  }

  private Void useIndexCtrl()
  {
    type = slanApp.resourceHelper.getType("IndexCtrl", dir)
  }

  private Str getTypeName(Str name)
  {
    if (name.endsWith("Ctrl"))
    {
      return name.capitalize
    }
    else
    {
      //suffix Ctrl
      return "${name}Ctrl".capitalize
    }
  }

  **
  ** find constructor and set restPath
  **
  private Void findConstructor()
  {
    //constructor parameter
    cparams := type.method("make").params
    constructorParams=ParameterHelper.getParams(restPath, cparams, 0)

    //rest path
    consumeResPath(cparams.size)
  }

  **
  ** find method and get methodParams using restPath
  **
  private Void findMethod()
  {
    //find method
    methodName := restPath.first
    if (methodName == null)
    {
      method = type.method("index")
      return
    }

    method = type.method(methodName, false)
    if (method != null)
    {
      consumeResPath
    }
    else
    {
      method = type.method("index")
    }
  }

  private Void findMethodParams()
  {
    methodParams = ParameterHelper.getParamsByName(req.uri.query, method.params, req.form)
  }

  ** put id on req.stash["id"]
  private Void setStashId()
  {
    if (restPath.size > 0)
    {
      req.stash["stashId"] = restPath[0]
      consumeResPath
    }
  }

  ** consume
  private Void consumeResPath(Int n := 1)
  {
    restPath = restPath[n..-1]
  }

  ** check for WebMethod facet
  private Bool checkWebMethod(Method m)
  {
    if (!m.isPublic) return false
    if (m.facets.size == 0) return true

    Bool allow := false
    switch(req.method)
    {
      case "GET":
        allow = m.hasFacet(WebGet#)
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
}