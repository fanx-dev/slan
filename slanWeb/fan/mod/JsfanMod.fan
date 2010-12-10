//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

using webmod
using web

**
** javascript mod
**
const class JsfanMod : WebMod
{
  private const Uri dir
  private const Uri[]? usings := null
  private const SlanApp slanApp

  new make(SlanApp slanApp, Uri dir, Uri[]? usings := null)
  {
    this.slanApp = slanApp
    this.dir = dir
    this.usings = usings
  }

  override Void onService()
  {
    typeName := req.uri.basename
    typeRes := slanApp.resourceHelper.findTypeUri(typeName, dir)
    if (typeRes is Str)
    {
      type := Pod.find(typeRes).type(typeName)
      res.headers["Content-Type"] = "text/html; charset=utf-8"
      slanApp.jsCompiler.renderByType(res.out, typeRes, type.qname, usings, [:])
    }
    else
    {
      file := (typeRes as Uri).get
      res.headers["Content-Type"] = "text/html; charset=utf-8"
      slanApp.jsCompiler.render(res.out, file, usings, [:])
    }
  }
}