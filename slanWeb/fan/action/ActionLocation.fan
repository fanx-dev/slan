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
  private Uri dir //action directory

  private Str[]? path
  private Str[]? restPath

  Type? type
  Method? method

  Obj?[]? constructorParams
  Obj?[]? methodParams


  new make(Uri dir)
  {
    this.dir = dir
  }

  This parse(Str[] path)
  {
    this.path = path

    findType(path.first)
    findConstructor
    findMethod

    return this
  }

  private Void findType(Str typeName)
  {
    type = ResourceHelper.i.getType(typeName, dir)
  }

  **
  ** find constructor and set restPath
  **
  private Void findConstructor()
  {
    //constructor parameter
    cparams := type.method("make").params
    constructorParams=ParameterHelper.getParams(path, cparams, 1)

    //rest path
    hasRestParams := path.size > (1 + cparams.size)
    restPath = hasRestParams ? path[(1 + cparams.size)..-1] : Str[,]
  }

  **
  ** find method and get methodParams using restPath
  **
  private Void findMethod()
  {
    //find method
    methodName := "index"
    if (restPath.size > 0)
    {
      methodName = restPath[0]
      if (restPath.size > 1)
      {
        //put id on req.stash["id"]
        req.stash["stashId"] = restPath[1]
      }
    }

    method = type.method(methodName)

    //check the facet
    if (!checkWebMethod(method))
    {
      res.sendErr(405)
      return
    }

    //getParams
    methodParams = ParameterHelper.getParamsByName(req.uri.query, method.params, req.form)
  }

  //check for WebMethod facet
  private Bool checkWebMethod(Method m)
  {
    if (!m.isPublic) return false
    if (m.facets.size == 0) return true
    if (req.method == "GET") return m.hasFacet(WebGet#)
    if (req.method == "POST") return m.hasFacet(WebPost#)
    return true
  }
}