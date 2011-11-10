//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

using web
using slanWeb

**
** route and template
**
const class Base : Controller
{
  Void index()
  {
    m->name = "world"
    m->compileJs = compileJs(`Hello.fwt`)
    render
  }

  @WebGet
  Void welcome()
  {
    m->name = stashId
    render
  }

  Str printInfo(Int i, Str? m){
    "$i,$m"
  }

  @WebPost
  Str post(Int i, Str m){
    "$i,$m"
  }
}