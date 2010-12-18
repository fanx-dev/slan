//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

using web
using slanWeb
using slanUtil

**
** route and template
**
class LocaleCtrl : SlanWeblet
{
  Void index()
  {
    render
  }

  override Void invoke(Str name, Obj?[]? args)
  {
    HttpTool().locale.use
    {
      this.trap(name, args)
      if (HttpTool().isOldIE)
      {
        res.out.w("You have an old browser")
      }
    }
  }
}