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
    compileJs(`hello.fwt`)
  }

  @WebGet
  Void welcome()
  {
    m->name = id
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
}