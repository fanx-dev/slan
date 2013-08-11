//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

using isql
using concurrent
using slanActor

**
** context with cache
**
const class CacheableContext : Context
{
  private const Log log := Pod.of(this).log

  **
  ** cache for object
  **
  const Cache objCache := Cache()

  **
  ** cache for query .
  ** the key is serialization string,value is id list.
  **
  const Cache queryCache := Cache()

  new make(Str curId := id)
   : super(curId) {}

  ////////////////////////////////////////////////////////////////////////
  // Tools
  ////////////////////////////////////////////////////////////////////////

  ** clear both objCache and queryCahe.
  Void clearCache()
  {
    currentObjCache.clear
    queryCache.clear
  }

  ////////////////////////////////////////////////////////////////////////
  // Object cache method
  ////////////////////////////////////////////////////////////////////////

  **
  ** Transaction will using a temporary cache.
  ** It is named 'tcache' in Actor.locals
  **
  private const static Str tcache := "slandao.CacheableContext.tcache"

  **
  ** if in the Transaction will return transaction temporary cache,
  ** or return objCache
  **
  private Cache currentObjCache()
  {
    return Actor.locals[tcache] ?: objCache
  }

  private Void set(Str key, Obj? value){ currentObjCache[key] = value }

  private Obj? get(Str key)
  {
    if (log.isDebug)
    {
        log.debug("using objCache:[$key]".replace("\n", ""))
    }
    return currentObjCache[key]
  }

  private Bool containsKey(Str key){ currentObjCache.containsKey(key) }

  Void removeCache(Str key){ currentObjCache.remove(key) }

  ////////////////////////////////////////////////////////////////////////
  // Query cache
  ////////////////////////////////////////////////////////////////////////
  **
  ** current will using query cache,
  **
  private Bool usingQueryCache()
  {
    return Actor.locals[tcache] == null //not in transcation
  }

  private Obj? queryGet(Str key)
  {
    if (log.isDebug)
    {
        log.debug("using queryCache:[$key]".replace("\n", ""))
    }
    return queryCache[key]
  }

  private Void querySet(Str key, Obj? obj)
  {
    queryCache.set(key, obj)
  }

  **
  ** clear the query cache which key satrts with typename + ','
  **
  Void clearQueryCache(Schema table)
  {
    name := table.name + ","
    queryCache.clearIf |Str key -> Bool|
    {
      key.startsWith(name)
    }
    if (log.isDebug)
    {
        log.debug("clear queryCache:[$name]")
    }
  }

  ////////////////////////////////////////////////////////////////////////
  // Execute write
  ////////////////////////////////////////////////////////////////////////

  override Void insert(Record obj)
  {
    super.insert(obj)
    set(objIdKey(obj), obj)
    clearQueryCache(obj.schema)
  }

  ** update by id
  override Void update(Record obj)
  {
    super.update(obj)
    set(objIdKey(obj), obj)
    clearQueryCache(obj.schema)
  }

  ** delete by example
  override Void deleteByExample(Record obj)
  {
    super.deleteByExample(obj)
    set(objIdKey(obj), null)
    clearQueryCache(obj.schema)
  }

  override Void deleteById(Schema table, Obj id)
  {
    super.deleteById(table, id)
    set(idToKey(table, id), null)
    clearQueryCache(table)
  }

  ** get object id as key
  private Str objIdKey(Record obj)
  {
    obj.schema.name + "," + (obj.getId)
  }

  private Str idToKey(Schema table, Obj id)
  {
    return table.name + "," + id
  }

  ////////////////////////////////////////////////////////////////////////
  // By ID
  ////////////////////////////////////////////////////////////////////////

  override Obj? findById(Schema table, Obj id)
  {
    key := idToKey(table, id)
    if (this.containsKey(key))
    {
      return get(key)
    }

    obj := super.findById(table, id)
    set(key, obj)
    return obj
  }

  ////////////////////////////////////////////////////////////////////////
  // Query Cache
  ////////////////////////////////////////////////////////////////////////

  ** count by example
  override Int count(Record obj)
  {
    if (!usingQueryCache) return super.count(obj)

    table := obj.schema
    sb := SqlUtil.makeKey(table, obj)
    key := "$obj.typeof.qname,count,$sb"

    if (queryCache.containsKey(key))
    {
      return queryGet(key)
    }

    n := super.count(obj)
    querySet(key, n)
    return n
  }

  ////////////////////////////////////////////////////////////////////////
  //transaction
  ////////////////////////////////////////////////////////////////////////

  ** transaction
  override Void trans(|This| f)
  {
      oauto := this.conn.autoCommit
      isNull := Actor.locals[tcache] == null
      try
      {
        this.conn.autoCommit = false
        if (isNull)
        {
          Actor.locals[tcache] = Cache()
        }

        f(this)

        this.conn.commit
        this.commitCaheTrans
      }
      catch (Err e)
      {
        this.conn.rollback
        throw e
      }
      finally
      {
        this.conn.autoCommit = oauto
        if (isNull)
        {
          Actor.locals[tcache] = null
        }
      }
  }

  **
  ** when transaction finish, to update the objectCache.
  ** the query already update instant
  **
  private Void commitCaheTrans()
  {
    Cache transactionCache := Actor.locals[tcache]
    objCache.addAll(transactionCache.getMap)
  }
}