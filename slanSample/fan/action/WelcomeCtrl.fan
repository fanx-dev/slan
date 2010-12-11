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
class WelcomeCtrl : SlanWeblet
{
  Void index()
  {
    m->name = "world"
    m->compileJs = compileJs(`Hello.fwt`)
  }

  @WebGet
  Void welcome()
  {
    m->name = stashId
  }

  Void printInfo(Int i, Str? m){
    writeContentType
    res.out.w("$i,$m")
  }

  @WebPost
  Void printInfo3(Int i, Str m){
    writeContentType
    res.out.w("$i,$m")
  }

  override Void before() { echo("before") }
  override Void after() { echo("after") }
  override Void finall() { echo("finall") }
}