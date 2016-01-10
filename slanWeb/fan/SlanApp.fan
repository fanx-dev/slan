//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-12-10  Jed Young  Creation
//

using build
using concurrent
using slanCompiler

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
  private const Str[] jsDepends

  ** static instance
  static const AtomicRef instance := AtomicRef()

  ** get static instance
  static SlanApp cur() { instance.val }

  ** init static instance
  static Void init(Str podName) {
    Str? appHome := Actor.locals["slan.appHome"]
    slanApp := SlanApp.make(podName, appHome.toUri)
    instance.val = slanApp

    echo("$podName, $slanApp.appHome")
  }

  ** new Product Mode
  private new make(Str podName, Uri? appHome)
  {
    if (appHome != null) {
      checkAppHome(appHome)
      isProductMode = false
      this.appHome = appHome
    } else {
      checkPodName(podName)
      isProductMode = true
    }
    this.podName = podName

    Str[] depends := [,]
    addJsDepends(depends, Pod.find(podName))
    jsDepends = depends

    jsCompiler = JsCompiler(this.jsDepends, this.podName)
    templateCompiler = SlanTemplate(this.podName)
    scriptCompiler = ScriptCompiler(this.podName)
  }

  **
  ** depends javascript pod names
  **
  private Void addJsDepends(Str[] depends, Pod pod)
  {
    pod.depends.each
    {
      p := Pod.find(it.name)
      addJsDepends(depends, p)

      if (p.file(`/${it.name}.js`, false) != null)
      {
        if (!depends.contains(it.name)) depends.add(it.name)
      }
    }
  }

  private Void checkAppHome(Uri appPath)
  {
    if (!appPath.isDir)  throw ArgErr("Invalid appHome:$appPath Directory need a slash")
    if (!`${appPath}build.fan`.toFile.exists)  throw ArgErr("Invalid appHome:$appPath not find build.fan")
  }

  private Void checkPodName(Str name)
  {
    Pod.find(name)
  }

//////////////////////////////////////////////////////////////////////////
// resourceHelper
//////////////////////////////////////////////////////////////////////////

  **
  ** res path. switch podFile or file
  **
  Uri getResUri(Uri path)
  {
    if (this.isProductMode)
    {
      return `fan://${this.podName}/$path`
    }
    else
    {
      return `${this.appHome}$path`
    }
  }

  **
  ** find type by script or pod.
  ** internal for JsfanMod#
  ** if product mode return podName
  **
  internal Obj findTypeUri(Str typeName, Uri dir)
  {
    if (this.isProductMode)
    {
      //find in pod
      //return `fan://$podName/$typeName`
      return this.podName
    }
    else
    {
      //find in file
      path := `${dir.toStr}${typeName}.fan`.toFile
      file := `${this.appHome}$path`
      return file
    }
  }

  Type? findType(Str typeName, Uri dir, Bool checked := true)
  {
    typeRes := findTypeUri(typeName, dir)
    if (typeRes is Str)
    {
      return Pod.find(typeRes).type(typeName, checked)
    }
    else
    {
      file := (typeRes as Uri).get(null, checked)
      if (file == null) return null
      type := scriptCompiler.getType(file)

      if (type.name != typeName)
        throw UnknownTypeErr("The file name not match the type name: $type.name != $file")
      return type
    }
  }

//////////////////////////////////////////////////////////////////////////
// Application tools
//////////////////////////////////////////////////////////////////////////

  private const ScriptCompiler scriptCompiler  **
  ** fantom to javascript compiler
  **
  const JsCompiler jsCompiler

  **
  ** html template to fantome class compiler
  **
  const TemplateCompiler templateCompiler
}


const class SlanTemplate : TemplateCompiler
{
  new make(Str? podName := null) : super(podName){
  }

  override File getFile(Uri uri) {
    slanApp := SlanApp.cur
    if (uri.ext == null) {
      uri = (`res/view/${uri}.html`)
    } else {
      uri = `res/view/${uri}`
    }
    file := slanApp.getResUri(uri).get
    return file
  }
}