//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-12-7  Jed.Y  Creation
//

using build

**
** Helper to find resource
**
const class ResourceHelper
{
  const static ResourceHelper i := ResourceHelper()
  private new make() {}

  **
  ** switch podFile or file
  **
  Uri getUri(Uri path)
  {
    if (Config.i.isProductMode)
    {
      return `fan://${Config.i.podName}/$path`
    }
    else
    {
      return `file:${Config.i.appHome}$path`
    }
  }

  **
  ** find type by script or pod
  **
  internal Obj findTypeUri(Str typeName, Uri dir)
  {
    if (Config.i.isProductMode)
    {
      //find in pod
      //return `fan://$podName/$typeName`
      return Config.i.podName
    }
    else
    {
      //find in file
      path := `${dir.toStr}${typeName}.fan`.toFile
      file := `file:${Config.i.appHome}$path`
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
      return ScriptCompiler.i.getType(file)
    }
  }
}