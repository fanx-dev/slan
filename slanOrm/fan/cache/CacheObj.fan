//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

**
** wrapper the object for cache
**
**
@Serializable
class CacheObj
{
  Duration lastAccess
  Obj? value
  const Str id
  const Duration expire
  const Duration createTime

  new make(|This| f)
  {
    f(this)
    lastAccess = Duration.now
    createTime = Duration.now
  }
}