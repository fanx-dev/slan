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
** static file service.
** The all directory and subdirectory is public
**
const class StaticFileMod : WebMod
{
  const Uri dir
  new make(Uri dir)
  {
    this.dir = dir
  }

  override Void onService()
  {
    rel := req.modRel.relTo(`/`)
    ps := dir + rel
    File file := Config.cur.getUri(ps).get
    FileWeblet(file).onService
  }
}