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
  static Config cur(){ return unsafe.val }

  private new make(){}

//////////////////////////////////////////////////////////////////////////
// field
//////////////////////////////////////////////////////////////////////////

  readonly Str? podName := null
  {
    get
    {
      if (&podName == null) { rebuild }
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

  **
  ** switch to product mode
  **
  Void toProductMode(Str podName)
  {
    isProductMode = true
    this.podName = podName
  }

  **
  ** switch to debug mode
  **
  Void toDebugMode(Uri appHome)
  {
    isProductMode = false
    this.appHome = appHome
  }

//////////////////////////////////////////////////////////////////////////
// build.fan
//////////////////////////////////////////////////////////////////////////

  **
  ** build.fan
  **
  internal Void rebuild()
  {
    podName = BuildCompiler.buildCompiler.runBuild(`${appHome}build.fan`.toFile)
  }
}