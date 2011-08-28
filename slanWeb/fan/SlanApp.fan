//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-12-10  Jed Young  Creation
//

using build
using concurrent

**
** Application Config
**
const class SlanApp
{
  **
  ** podName
  **
  const Str? podName

  **
  ** parent folder
  **
  const Uri? appHome

  **
  ** default is debugMode
  **
  const Bool isProductMode

  ** new Debug Mode
  new makeDebug(Uri appHome)
  {
    checkAppHome(appHome)

    isProductMode = false
    this.appHome = appHome

    type := Env.cur.compileScript(`${appHome}build.fan`.toFile)
    BuildPod build := type.make
    podName = build.podName
  }

  ** new Product Mode
  new makeProduct(Str podName)
  {
    checkPodName(podName)

    isProductMode = true
    this.podName = podName
  }

  ** just pod names
  Str[] depends()
  {
    Str[] depends := [,]
    Pod.find(podName).depends.each
    {
      depends.add(it.name)
    }
    return depends
  }

  private Void checkAppHome(Uri appPath)
  {
    if (!appPath.isDir)  throw ArgErr("Invalid appHome. Directory need a slash")
    if (!`${appPath}build.fan`.toFile.exists)  throw ArgErr("Invalid appHome. not find build.fan")
  }

  private Void checkPodName(Str name)
  {
    Pod.find(name)
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
}