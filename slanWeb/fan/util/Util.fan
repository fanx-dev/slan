//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-12-20  Jed Young  Creation
//

using util
using wisp
using web
using concurrent

**
** comment line tool
**
class Util
{
  **
  ** get sub dir list, all uri rel to base
  **
  static Uri[] allDir(Uri base, Uri dir)
  {
    Uri[] subs := [,]
    (base + dir).toFile.walk |File f|
    {
      if(f.isDir)
      {
        rel := f.uri.relTo(base)
        subs.add(rel)
      }
    }
    return subs
  }
}