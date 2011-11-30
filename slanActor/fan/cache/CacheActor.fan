//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2011-11-27  Jed Young  Creation
//

using concurrent

**
** cache object and intime clearup
**
const class CacheActor : AsyActor
{
  const Int maxNum
  const Int halfNum
  private const ActorLocal cacheMap := ActorLocal()
  private const Log log := Pod.of(this).log

  new make(Int maxNum := 500) : super(ActorPool())
  {
    this.maxNum = maxNum
    halfNum = maxNum / 2
  }

  CacheObj? _get(Str key)
  {
    obj := map.get(key)
    if(obj == null) return null
    obj.updateLastAccess
    return obj
  }

  Void _set(Str key, CacheObj? obj)
  {
    clean
    map.set(key, obj)
  }

  ** remove by key
  Void _remove(Str key) { map.remove(key) }

  ** contains the Key
  Bool _containsKey(Str key) { map.containsKey(key) }

  ** remove all
  Void _clear(){ this.map.clear }

  **
  ** get current cache map
  **
  private [Str:CacheObj] map()
  {
    map := cacheMap.get
    if (map == null)
    {
      map = Str:CacheObj[:]
      cacheMap.set(map)
    }
    return map
  }

//////////////////////////////////////////////////////////////////////////
// clear
//////////////////////////////////////////////////////////////////////////

  **
  ** clear half object if more than maxNum.
  **
  private Void clean()
  {
    map := this.map
    if (map.size < maxNum) return

    log.debug("before clean: " + map.size)
    //sort
    CacheObj[] list := map.vals.sort |CacheObj a, CacheObj b->Int| { return a.lastAccess <=> b.lastAccess }

    //remove
    for (i:=0; i<halfNum; ++i)
    {
      map.remove(list[i].key)
    }

    log.debug("after clean: " + map.size)
    Env.cur.gc
  }
}