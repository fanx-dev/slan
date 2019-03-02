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
const class Template : Controller
{
  Void get()
  {
    stash("name", stashId)
    render(`template/template.html`)
  }
}