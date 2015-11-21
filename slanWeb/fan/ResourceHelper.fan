//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-12-7  Jed Young  Creation
//

using build
using slanCompiler

**
** Helper to find resource
**
const class ResourceHelper
{
  private const SlanApp slanApp
  private const ScriptCompiler scriptCompiler

  new make(SlanApp slanApp)
  {
    this.slanApp = slanApp
    scriptCompiler = ScriptCompiler(slanApp.podName)
  }

  **
  ** res path. switch podFile or file
  **
  Uri getUri(Uri path)
  {
    if (slanApp.isProductMode)
    {
      return `fan://${slanApp.podName}/$path`
    }
    else
    {
      return `${slanApp.appHome}$path`
    }
  }

  **
  ** find type by script or pod.
  ** internal for JsfanMod#
  ** if product mode return podName
  **
  internal Obj findTypeUri(Str typeName, Uri dir)
  {
    if (slanApp.isProductMode)
    {
      //find in pod
      //return `fan://$podName/$typeName`
      return slanApp.podName
    }
    else
    {
      //find in file
      path := `${dir.toStr}${typeName}.fan`.toFile
      file := `${slanApp.appHome}$path`
      return file
    }
  }

  Type? getType(Str typeName, Uri dir, Bool checked := true)
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
}