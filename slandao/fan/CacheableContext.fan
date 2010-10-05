//
// Copyright (c) 2010 Yang Jiandong
// Licensed under Eclipse Public License version 1.0
//
// History:
//   yangjiandong 2010-10-1 - Initial Contribution
//

using sql
using concurrent

**
** context with cache
**
const class CacheableContext:Context
{
  private const Log log:=Pod.of(this).log
  ** 
  ** cache for object
  ** 
  const Cache objCache:=Cache()
  ** 
  ** cache for query .
  ** the key is serialization string,value is id list.
  ** 
  const Cache queryCache:=Cache()
  
  new make(SqlService db,Type:Table tables):super(db,tables){
  }
  
  ////////////////////////////////////////////////////////////////////////
  //tools
  ////////////////////////////////////////////////////////////////////////
  
  **
  ** clearDatabase,tryCreateAllTable,clearCache
  ** 
  Void refreshDatabase(){
    clearDatabase
    tryCreateAllTable
    clearCache
  }
  
  ** clear both objCache and queryCahe.
  Void clearCache(){
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
  private const static Str tcache:="slandao.CacheContext.tcache"
  
  ** 
  ** if in the Transaction will return transaction temporary cache,
  ** or return objCache
  ** 
  private Cache currentObjCache(){
    return Actor.locals[tcache]?:objCache
  }
  
  private Void set(Str key,Obj? value){ currentObjCache[key]=value }
  
  private Obj? get(Str key){
    if(log.isDebug){
        log.debug("using objCache:[$key]".replace("\n",""))
    }
    return currentObjCache[key]
  }
  
  private Bool containsKey(Str key){ currentObjCache.containsKey(key) }
  
  Void removeCache(Str key){ currentObjCache.remove(key)}
  
  ////////////////////////////////////////////////////////////////////////
  //query cache
  ////////////////////////////////////////////////////////////////////////
  **
  ** current will using query cache,
  ** 
  private Bool usingQueryCache(){
    return Actor.locals[tcache]==null//not in transcation
  }
  
  private Obj? queryGet(Str key){
    if(log.isDebug){
        log.debug("using queryCache:[$key]".replace("\n",""))
    }
    return queryCache[key]
  }
  
  private Void querySet(Str key,Obj? obj){
    queryCache.set(key,obj,1min)
  }
  **
  ** clear the query cache which key satrts with typename + ','
  ** 
  Void clearQueryCache(Type type){
    name:=type.qname+","
    queryCache.clearIf|Str key->Bool|{
      key.startsWith(name)
    }
    if(log.isDebug){
        log.debug("clear queryCache:[$name]")
    }
  }
  
  ////////////////////////////////////////////////////////////////////////
  //execute write
  ////////////////////////////////////////////////////////////////////////

  override Void insert(Obj obj){
    super.insert(obj)
    table:=getTable(obj.typeof)
    set(objKey(obj),obj)
    clearQueryCache(obj.typeof)
  }
  
  override Void update(Obj obj){
    super.update(obj)
    table:=getTable(obj.typeof)
    set(objKey(obj),obj)
    clearQueryCache(obj.typeof)
  }
  
  override Void delete(Obj obj){
    super.delete(obj)
    table:=getTable(obj.typeof)
    set(objKey(obj),null)
    clearQueryCache(obj.typeof)
  }
  
  private Str objKey(Obj obj){
    obj.typeof.qname+","+getId(obj)
  }
  
  ////////////////////////////////////////////////////////////////////////
  //by ID
  ////////////////////////////////////////////////////////////////////////
  
  override Obj? findById(Type type,Obj id){
    table:=getTable(type)
    key:=type.qname+","+id
    if(this.containsKey(key)){
      return get(key)
    }
    
    obj:= super.findById(type,id)
    set(key,obj)
    return obj
  }
  
  ////////////////////////////////////////////////////////////////////////
  //Query Cache
  ////////////////////////////////////////////////////////////////////////
  
  protected override Obj[] getIdList(Obj obj,Str orderby,Int start,Int num){
    if(!usingQueryCache)return super.getIdList(obj,orderby,start,num)
    
    key:=getKey(obj,orderby,start,num)
    if(queryCache.containsKey(key)){
      return queryGet(key)
    }
    
    ids:= super.getIdList(obj,orderby,start,num)
    querySet(key,ids)
    return ids
  }
  private Str getKey(Obj obj,Str orderby,Int start,Int num){
    sb:= StrBuf()
    sb.out.writeObj(obj)
    type:=obj.typeof
    return "$type.qname,selectId,$sb.toStr,$orderby,$start,$num"
  }
  
  override Obj[] getWhereIdList(Type type,Str where,Int start:=0,Int num:=20){
    if(!usingQueryCache)return super.getWhereIdList(type,where,start,num)
    
    key:="$type.qname,selectWhere,$where,$start,$num"
    if(queryCache.containsKey(key)){
      return queryGet(key)
    }
    
    ids:= super.getWhereIdList(type,where,start,num)
    querySet(key,ids)
    return ids
  }
  
  override Int count(Obj obj){
    if(!usingQueryCache)return super.count(obj)
    
    sb:= StrBuf()
    sb.out.writeObj(obj)
    type:=obj.typeof
    key:="$type.qname,count,$sb.toStr"
    
    if(queryCache.containsKey(key)){
      return queryGet(key)
    }
    
    n:= super.count(obj)
    querySet(key,n)
    return n
  }
  
  ////////////////////////////////////////////////////////////////////////
  //transaction
  ////////////////////////////////////////////////////////////////////////
  
  ** transaction
  override Void trans(|This| f){
    oauto:=db.autoCommit
    isNull:=Actor.locals[tcache]==null
    try{
      db.autoCommit=false
      if(isNull){
        Actor.locals[tcache]=Cache()
      }
      
      f(this)
      
      db.commit
      commitCaheTrans
      
    }catch(Err e){
      db.rollback
      throw e
    }finally{
      db.autoCommit=oauto
      if(isNull){
        Actor.locals[tcache]=null
      }
    }
  }
  ** 
  ** when transaction finish, to update the objectCache.
  ** the query already update instant
  ** 
  private Void commitCaheTrans(){
    Cache transactionCache:=Actor.locals[tcache]
    objCache.mergeCache(transactionCache.getMap)
  }
}
