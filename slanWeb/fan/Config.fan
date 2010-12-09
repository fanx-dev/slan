//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed.Y  Creation
//

using build

**
** Config
**
class Config
{
  ** do not change this once init
  private static const Unsafe unsafe := Unsafe(Config())
  static Config i(){ return unsafe.val }

  private new make(){}

//////////////////////////////////////////////////////////////////////////
// field
//////////////////////////////////////////////////////////////////////////

  readonly Str? podName := null
  {
    get
    {
      if (&podName == null) { ModelKeeper.i.rebuild }
      return &podName
    }
  }

  **
  ** parent folder
  **
  readonly Uri appHome := ``
  {
    get
    {
      if (isProductMode) throw Err("productMode no appHome")
      return &appHome
    }
  }

  **
  ** default is debugMode
  **
  readonly Bool isProductMode := false


  private Bool inited := false

  **
  ** switch to product mode
  **
  Void toProductMode(Str podName)
  {
    if (inited) throw Err("already inited")

    isProductMode = true
    this.podName = podName

    inited = true
  }

  **
  ** switch to debug mode
  **
  Void toDebugMode(Uri appPath)
  {
    if (inited) throw Err("already inited")

    checkAppHome(appPath)

    isProductMode = false
    appHome = appPath

    inited = true
  }

  private Void checkAppHome(Uri appPath)
  {
    if (!appPath.isDir)  throw ArgErr("Invalid appHome. Directory need a slash")
    if (!`${appPath}build.fan`.toFile.exists)  throw ArgErr("Invalid appHome. not find build.fan")
  }

//////////////////////////////////////////////////////////////////////////
// build.fan
//////////////////////////////////////////////////////////////////////////

  **
  ** only for debug mode, call by modelKeeper
  **
  internal Void setPodName(Str name)
  {
    if (isProductMode) throw Err("toProductMode")
    podName = name
  }

  private SlanRouteMod? rootMod
  internal SlanRouteMod getRootMod()
  {
    if (rootMod == null || !isProductMode)
    {
      copyPodName := podName
      type := ResourceHelper.i.getType("RootMod", `fan/special/`)
      rootMod = type.make()

      //guarantee podname not be modify
      podName = copyPodName
    }
    return rootMod
  }
}