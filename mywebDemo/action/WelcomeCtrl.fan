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
** welcome
**
class WelcomeCtrl : SlanWeblet
{
  Void index()
  {
    req.stash["name"] = m->id
    compileJs(`hello.fwt`)
  }

  @WebGet
  Void welcome()
  {
    req.stash["name"] = m->id
  }

  Void fwt()
  {
    renderFwt(`hello.fwt`)
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