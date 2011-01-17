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

  private Str[]? remainderPath

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
    this.remainderPath = path

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
    name := remainderPath.first
    if(name == null)
    {
      useIndexCtrl
      return
    }

    type = slanApp.resourceHelper.getType(name, dir, false)
    if (type != null)
      consumePath
    else
      useIndexCtrl
  }

  private Void useIndexCtrl()
  {
    type = slanApp.resourceHelper.getType("Index", dir)
  }

  **
  ** find constructor and set restPath
  **
  private Void findConstructor()
  {
    //constructor parameter
    cparams := type.method("make").params
    constructorParams=ParameterHelper.getParams(remainderPath, cparams, 0)

    //remainder path
    consumePath(cparams.size)
  }

  **
  ** find method and get methodParams using restPath
  **
  private Void findMethod()
  {
    //find method
    methodName := remainderPath.first

    //index or create
    if (methodName == null)
    {
      if(req.method == "GET")
        method = type.method("index")
      else if(req.method == "POST")
        method = type.method("post")//create
      else
        method = type.method("index")
      return
    }

    method = type.method(methodName, false)
    //named op
    if (method != null)
    {
      consumePath
      return
    }

    //resource op
    switch(req.method)
    {
      case "GET":
        method = type.method("get")//show
      case "DELETE":
        method = type.method("delete")//destroy
      case "PUT":
        method = type.method("put")//update
      default:
        method = type.method("get")
    }
  }

  private Void findMethodParams()
  {
    methodParams = ParameterHelper.getParamsByName(req.uri.query, method.params, req.form)
  }

  ** put id on req.stash
  private Void setStashId()
  {
    if (remainderPath.size > 0)
    {
      req.stash["_stashId"] = remainderPath[0]
      consumePath
    }
  }

  ** consume
  private Void consumePath(Int n := 1)
  {
    remainderPath = remainderPath[n..-1]
  }

  ** check for WebMethod facet
  private Bool checkWebMethod(Method m)
  {
    if (!m.isPublic) return false
    if (!hasLimitFacet(m)) return true
    return allow(m)
  }

  private Bool allow(Method m)
  {
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

  private Bool hasLimitFacet(Method m)
  {
    firstLimit := facets.find{ m.hasFacet(it) }
    return firstLimit != null
  }

  private const static Type[] facets :=
    [WebGet#, WebPost#, WebPut#, WebDelete#, WebHead#, WebTrace#, WebOptions#]
}