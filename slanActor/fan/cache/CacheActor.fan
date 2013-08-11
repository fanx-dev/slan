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
  private const ActorLocal cacheMap := ActorLocal()
  private const Log log := Pod.of(this).log

  new make(Int maxNum := 500) : super(ActorPool())
  {
    this.maxNum = maxNum
  }

  Obj? _get(Str key)
  {
    obj := map.get(key)

    //move to last
    map.remove(key)
    map[key] = obj

    return obj
  }

  Void _set(Str key, Obj? obj)
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
  private [Str:Obj?] map()
  {
    map := cacheMap.get
    if (map == null)
    {
      map = Str:Obj?[:] { ordered = true }
      cacheMap.set(map)
    }
    return map
  }

  [Str:Obj?] _getMap() { map }

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
    keys := map.keys
    //echo(keys)

    //remove
    halfNum := maxNum / 2
    for (i:=0; i<halfNum; ++i)
    {
      v := map.remove(keys[i])
      if (v != null && v is CacheValue)
      {
        ((CacheValue)v).onRemove
      }
    }

    log.debug("after clean: " + map.size)
    Env.cur.gc
  }

//////////////////////////////////////////////////////////////////////////
// Other
//////////////////////////////////////////////////////////////////////////

  Void _addAll([Str:Obj?] target)
  {
    srcous := map
    target.each |Obj? value, Str key|
    {
      srcous[key]=value
      if (log.isDebug)
      {
        log.debug("commitCahe:[$key:$value]".replace("\n",""))
      }
    }
  }

  Void _clearIf(|Str -> Bool| f)
  {
    old := Str[,]
    map.each |v,k|
    {
      if (f(k)) old.add(k)
    }
    old.each { map.remove(it) }
  }

}