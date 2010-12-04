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
  static Config cur()
  {
    return unsafe.val
  }

  private new make(){}

  private Str? podName := null
  private Uri? appHome := null

  ** default is debugMode
  private Bool productMode := false

  **
  ** switch to product mode
  **
  Void toProductMode(Str podName)
  {
    productMode = true
    this.podName = podName
  }

  **
  ** switch to debug mode
  **
  Void toDebugMode(Uri? appHome)
  {
    productMode = false
    this.appHome = appHome
  }

  **
  ** get pod name. if debugMod pull from build.fan
  **
  Str getPodName()
  {
     if (podName == null)
     {
       BuildPod build := Env.cur.compileScript(getUri(`build.fan`).toFile).make
       podName = build.podName
     }
     return podName
  }

  **
  ** switch podFile or file
  **
  Uri getUri(Uri path)
  {
    if (!productMode)
    {
      return appHome == null ? `file:$path` : `file:$appHome$path`
    }
    else
    {
      return `fan://$podName/$path`
    }
  }

  **
  ** find type by script or pod
  **
  Obj findTypeUri(Str typeName, Uri dir)
  {
    if (!productMode)
    {
      //find in file
      path := `${dir.toStr}${typeName}.fan`.toFile
      file := appHome == null ? `file:$path` : `file:$appHome$path`
      return file
    }
    else
    {
      //find in pod
      //return `fan://$podName/$typeName`
      return podName
    }
  }
}