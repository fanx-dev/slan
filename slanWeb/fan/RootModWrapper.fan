//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

using web

**
** wrap root for debug
**
internal const class RootModWrapper : WebMod
{
  private const SlanApp slanApp

  new make(Uri appHome)
  {
    this.slanApp = SlanApp.makeDebug(appHome)
  }

  **
  ** custom root web mod
  **
  private SlanRouteMod getRootMod()
  {
    if (!slanApp.isProductMode)
    {
      type := slanApp.resourceHelper.getType("RootMod", `fan/special/`)
      return type.make([slanApp])
    }
    throw Err("unsuppert")
  }

  override Void onService()
  {
    getRootMod.onService
  }

  override Void onStart() { getRootMod.onStart }

  override Void onStop() { getRootMod.onStop }
}