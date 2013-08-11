//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2011-11-27  Jed Young  Creation
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

  @Operator
  Obj? get(Str key)
  {
    obj := (cache->get(key) as Future).get
    if (safe) return obj
    else return ((Unsafe)obj).val
  }

  @Operator
  Void set(Str key, Obj? val)
  {
    Obj? obj
    if (safe)
    {
      obj = val
    }
    else
    {
      obj = Unsafe(val)
    }

    cache->set(key, obj)
  }

  ** remove by key
  Void remove(Str key) { cache->remove(key) }

  ** contains the Key
  Bool containsKey(Str key) { cache->containsKey(key) }

  ** remove all
  Void clear(){ cache->clear }

  Void addAll([Str:Obj?] target) { cache->allAll(target) }

  Void clearIf(|Str -> Bool| f) { cache->clearIf(f) }

  [Str:Obj?] getMap() { cache->getMap }
}