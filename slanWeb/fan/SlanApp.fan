//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-12-10  Jed.Y  Creation
//

using build
using concurrent

**
** Application Config
**
const class SlanApp
{
  **
  ** store podName
  **
  private const AtomicRef podNameRef := AtomicRef()

  **
  ** parent folder
  **
  const Uri? appHome

  **
  ** default is debugMode
  **
  const Bool isProductMode


  new makeDebug(Uri appHome)
  {
    checkAppHome(appHome)

    isProductMode = false
    this.appHome = appHome
  }

  new makeProduct(Str podName)
  {
    isProductMode = true
    podNameRef.getAndSet(podName)
  }

  **
  ** get current podName
  **
  Str podName()
  {
    if (podNameRef.val == null)
    {
      modelKeeper.rebuild
    }
    return podNameRef.val
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
  ** only for debug mode, called by modelKeeper
  **
  internal Void setPodName(Str name)
  {
    if (isProductMode) throw Err("producteMode do not change podName")
    podNameRef.getAndSet(name)
  }

  **
  ** custom root web mod
  **
  internal SlanRouteMod getRootMod()
  {
    if (!isProductMode)
    {
      type := resourceHelper.getType("RootMod", `fan/special/`)
      return type.make([this])
    }
    throw Err("unsuppert")
  }

//////////////////////////////////////////////////////////////////////////
// Application tools
//////////////////////////////////////////////////////////////////////////

  const ResourceHelper resourceHelper := ResourceHelper(this)

  **
  ** fantom script compiler
  **
  const ScriptCompiler scriptCompiler := ScriptCompiler(this)//internal cache

  **
  ** fantom to javascript compiler
  **
  const JsCompiler jsCompiler := JsCompiler(this)

  **
  ** html template to fantome class compiler
  **
  const TemplateCompiler templateCompiler := TemplateCompiler(this)

  **
  ** detect model change and rebuild pod
  **
  internal const ModelKeeper modelKeeper := ModelKeeper(this)
}