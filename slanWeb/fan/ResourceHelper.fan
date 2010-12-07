//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed.Y  Creation
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
    if (Config.cur.isProductMode)
    {
      return `fan://${Config.cur.podName}/$path`
    }
    else
    {
      return `file:${Config.cur.appHome}$path`
    }
  }

  **
  ** find type by script or pod
  **
  Obj findTypeUri(Str typeName, Uri dir)
  {
    if (Config.cur.isProductMode)
    {
      //find in pod
      //return `fan://$podName/$typeName`
      return Config.cur.podName
    }
    else
    {
      //find in file
      path := `${dir.toStr}${typeName}.fan`.toFile
      file := `file:${Config.cur.appHome}$path`
      return file
    }
  }
}