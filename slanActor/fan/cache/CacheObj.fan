//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2011-11-27  Jed Young  Creation
//

**
** wrapper the object for cache
**
**

mixin CacheValue
{
  abstract Void onRemove()
}

internal const class UnsafeCacheObj
{
  const Unsafe mutable

  private Obj? obj() { mutable.val }

  new make(Obj? val)
  {
    mutable = Unsafe(val)
  }
}