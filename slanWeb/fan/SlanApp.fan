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

  **
  ** depends javascript pod names
  **
  const Str[] jsDepends

  ** new Debug Mode
  new makeDebug(Uri appHome)
  {
    checkAppHome(appHome)

    isProductMode = false
    this.appHome = appHome

    type := Env.cur.compileScript(`${appHome}build.fan`.toFile)
    BuildPod build := type.make
    podName = build.podName

    Str[] depends := [,]
    addJsDepends(depends, podName)
    jsDepends = depends

    resourceHelper = ResourceHelper(this)
    jsCompiler = JsCompiler(this.jsDepends, this.podName)
    templateCompiler = TemplateCompiler(this.podName)
  }

  ** new Product Mode
  new makeProduct(Str podName)
  {
    checkPodName(podName)

    isProductMode = true
    this.podName = podName

    Str[] depends := [,]
    addJsDepends(depends, podName)
    jsDepends = depends

    resourceHelper = ResourceHelper(this)
    jsCompiler = JsCompiler(this.jsDepends, this.podName)
    templateCompiler = TemplateCompiler(this.podName)
  }

  **
  ** depends javascript pod names
  **
  private Void addJsDepends(Str[] depends, Str podName)
  {
    Pod.find(podName).depends.each
    {
      pod := Pod.find(it.name)
      if (pod.file(`/${it.name}.js`, false) != null)
        depends.add(it.name)

      addJsDepends(depends, it.name)
    }
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

  const ResourceHelper resourceHelper

  **
  ** fantom to javascript compiler
  **
  const JsCompiler jsCompiler

  **
  ** html template to fantome class compiler
  **
  const TemplateCompiler templateCompiler
}