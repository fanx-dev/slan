//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

using sql
using concurrent

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

  new make(SqlServ db, Type:Table tables) : super(db, tables){}

  ////////////////////////////////////////////////////////////////////////
  //tools
  ////////////////////////////////////////////////////////////////////////

  **
  ** clearDatabase,tryCreateAllTable,clearCache
  **
  Void refreshDatabase()
  {
    clearDatabase
    tryCreateAllTable
    clearCache
  }

  ** clear both objCache and queryCahe.
  Void clearCache()
  {
    currentObjCache.clearAll
    queryCache.clearAll
  }

  ////////////////////////////////////////////////////////////////////////
  //object cache method
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
  //query cache
  ////////////////////////////////////////////////////////////////////////
  **
  ** current will using query cache,
  **
  private Bool usingQueryCache()
  {
    return Actor.locals[tcache] == null//not in transcation
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
    queryCache.set(key, obj, 1min)
  }
  **
  ** clear the query cache which key satrts with typename + ','
  **
  Void clearQueryCache(Type type)
  {
    name := type.qname + ","
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
  //execute write
  ////////////////////////////////////////////////////////////////////////

  override Void insert(Obj obj)
  {
    super.insert(obj)
    set(objIdKey(obj), obj)
    clearQueryCache(obj.typeof)
  }

  ** update by id
  override Void update(Obj obj)
  {
    super.update(obj)
    set(objIdKey(obj), obj)
    clearQueryCache(obj.typeof)
  }

  ** delete by example
  override Void deleteByExample(Obj obj)
  {
    super.deleteByExample(obj)
    set(objIdKey(obj), null)
    clearQueryCache(obj.typeof)
  }

  override Void deleteById(Type type, Obj id)
  {
    super.deleteById(type, id)
    set(idToKey(type, id), null)
    clearQueryCache(type)
  }

  ** get object id as key
  private Str objIdKey(Obj obj)
  {
    obj.typeof.qname + "," + getId(obj)
  }

  private Str idToKey(Type type, Obj id)
  {
    return type.qname + "," + id
  }

  ////////////////////////////////////////////////////////////////////////
  //by ID
  ////////////////////////////////////////////////////////////////////////

  override Obj? findById(Type type, Obj id)
  {
    table := getTable(type)
    key := idToKey(type, id)
    if (this.containsKey(key))
    {
      return get(key)
    }

    obj := super.findById(type, id)
    set(key, obj)
    return obj
  }

  ////////////////////////////////////////////////////////////////////////
  //Query Cache
  ////////////////////////////////////////////////////////////////////////

  protected override Obj[] getIdList(Obj obj, Str orderby, Int offset, Int limit)
  {
    if (!usingQueryCache) return super.getIdList(obj, orderby, offset, limit)

    table := getTable(obj.typeof)
    sb := table.makeKey(obj)
    key := "${obj.typeof.qname},selectId,$sb,$orderby,$offset,$limit"

    if (queryCache.containsKey(key))
    {
      return queryGet(key)
    }

    ids := super.getIdList(obj, orderby, offset, limit)
    querySet(key, ids)
    return ids
  }

  override Obj[] getWhereIdList(Type type, Str condition, Int offset := 0, Int limit := 50)
  {
    if (!usingQueryCache) return super.getWhereIdList(type, condition, offset, limit)

    key := "$type.qname,selectWhere,$condition,$offset,$limit"
    if (queryCache.containsKey(key))
    {
      return queryGet(key)
    }

    ids := super.getWhereIdList(type, condition, offset, limit)
    querySet(key, ids)
    return ids
  }

  ** count by example
  override Int count(Obj obj)
  {
    if (!usingQueryCache) return super.count(obj)

    type := obj.typeof
    table := getTable(type)
    sb := table.makeKey(obj)
    key := "$type.qname,count,$sb"

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
      oauto := this.db.autoCommit
      isNull := Actor.locals[tcache] == null
      try
      {
        this.db.autoCommit = false
        if (isNull)
        {
          Actor.locals[tcache] = Cache()
        }

        f(this)

        this.db.commit
        this.commitCaheTrans
      }
      catch (Err e)
      {
        this.db.rollback
        throw e
      }
      finally
      {
        this.db.autoCommit = oauto
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
    objCache.mergeCache(transactionCache.getMap)
  }
}