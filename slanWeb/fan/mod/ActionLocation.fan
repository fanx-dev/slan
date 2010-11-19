//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed.Y  Creation
//

using web

**
** find Ctrller#action and fill params
**
class ActionLocation : Weblet
{
  //private Str? podName //current pod name
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

  This execute(Str[] path)
  {
    this.path = path

    findType(path.first)
    findConstructor
    findMethod

    return this
  }

  private Void findType(Str typeName)
  {
    typeRes := Config.cur.findTypeUri(typeName, dir)
    if (typeRes is Str)
    {
      type = Pod.find(typeRes).type(typeName)
    }
    else
    {
      file := (typeRes as Uri).get
      type = Env.cur.compileScript(file)
    }
  }

  **
  ** find constructor and set restPath
  **
  private Void findConstructor()
  {
    //constructor parameter
    cparams := type.method("make").params
    constructorParams=SlanUtil.getParams(path, cparams, 1)

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
        req.stash["id"] = restPath[1]
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
    methodParams = SlanUtil.getParamsByName(req.uri.query, method.params, req.form)
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