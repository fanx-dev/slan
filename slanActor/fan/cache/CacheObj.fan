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

mixin CacheObj
{
  abstract Duration lastAccess()
  abstract Void updateLastAccess()

  abstract Obj? value()
  abstract Str key()
}

@Serializable
internal class MutableCacheObj : CacheObj
{
  override Duration lastAccess
  override Obj? value
  override Str key

  override Void updateLastAccess() { lastAccess = Duration.now }

  new make(Obj? val, Str key)
  {
    value = val
    this.key = key
    lastAccess = Duration.now
  }
}

internal const class UnsafeCacheObj : CacheObj
{
  const Unsafe mutable

  private MutableCacheObj obj() { mutable.val }

  override Duration lastAccess() { obj.lastAccess }
  override Obj? value() { obj.value }
  override Str key() { obj.key }
  override Void updateLastAccess() { obj.updateLastAccess }

  new make(Obj? val, Str key)
  {
    mutable = Unsafe(MutableCacheObj(val, key))
  }
}