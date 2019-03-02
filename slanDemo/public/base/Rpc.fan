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
const class Rpc : Controller
{
  Int printInfo(Int a, Int b){
    a+b
  }

  @WebPost
  Str post(Int i, Str m){
    "$i,$m"
  }

  ** ajax for `jsfan/TableFwt.fan`
  Obj data()
  {
     [
        ["key","value"],
        ["1","yjd"],
        ["2","yqq"]
     ]
  }
}