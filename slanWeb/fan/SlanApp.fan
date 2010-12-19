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
  ** podName on productMode
  **
  private const Str? productPodName

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
  }

  ** new Product Mode
  new makeProduct(Str podName)
  {
    checkPodName(podName)

    isProductMode = true
    productPodName = podName
  }

  **
  ** get current podName
  **
  Str podName()
  {
    if (isProductMode) return productPodName

    if (podNameRef.val == null)
    {
      //on service started
      podName := directlyRunBuildScript
      podNameRef.getAndSet(podName)
    }
    return podNameRef.val
  }

  **
  ** run build script directly
  **
  private Str directlyRunBuildScript()
  {
    type := Env.cur.compileScript(`${appHome}build.fan`.toFile)
    BuildPod build := type.make
    build.compile
    return build.podName
  }

  **
  ** js using need this
  **
  internal Str realPodName()
  {
    if (isProductMode) return productPodName
    name := podName
    i := name.index("_")
    if (i == null) return name
    return name[0..<i]
  }

  Str[] depends()
  {
    podName := realPodName
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

  **
  ** only for debug mode, called by modelKeeper
  **
  internal Void setPodName(Str name)
  {
    if (isProductMode) throw Err("producteMode do not change podName")
    podNameRef.getAndSet(name)
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