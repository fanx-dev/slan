//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-12-7  Jed Young  Creation
//

using web

**
** Filter
**
const class Filter : Weblet
{
  ** return false will cancle the request
  protected override Bool beforeInvoke()
  {
    return true
  }

  ** guarantee will be called
  protected override Void afterInvoke() {}
}