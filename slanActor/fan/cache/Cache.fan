//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

using concurrent

**
** cache
**
const class Cache
{
  private const CacheActor cache
  private const Bool safe

  new make(Int maxNum := 500, Bool safe := true)
  {
    cache = CacheActor(maxNum)
    this.safe = safe
  }

  Obj? get(Str key)
  {
    CacheObj? obj := cache->get(key)
    if(obj == null) return null
    return obj.value
  }

  Void set(Str key, Obj? val)
  {
    CacheObj? obj
    if (val == null)
    if (safe)
    {
      if (val == null)
      {
        obj = UnsafeCacheObj(val, key)
      }
      else if (val.isImmutable)
      {
        val.toImmutable
        obj = UnsafeCacheObj(val, key)
      }
      else
      {
        obj = MutableCacheObj(val, key)
      }
    }
    else
    {
      obj = UnsafeCacheObj(val, key)
    }

    cache->set(key, obj)
  }

  ** remove by key
  Void remove(Str key) { cache->remove(key) }

  ** contains the Key
  Bool containsKey(Str key) { cache->containsKey(key) }

  ** remove all
  Void clear(){ cache->clear }
}