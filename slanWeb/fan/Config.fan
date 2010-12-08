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
  Void toDebugMode(Uri appHome)
  {
    if (inited) throw Err("already inited")

    if (!checkAppHome(appHome)) throw ArgErr("Invalid appHome. Directory need a slash")

    isProductMode = false
    this.appHome = appHome

    inited = true
  }

  private Bool checkAppHome(Uri home)
  {
    if (!home.isDir) return false
    if (!`${appHome}build.fan`.toFile.exists) return false
    return true
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