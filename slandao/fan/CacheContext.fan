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
**
**
const class CacheContext:Context
{
  const Cache cache:=Cache()
  private const Log log:=Pod.of(this).log
  const Cache? queryCache
  
  new make(SqlService db,Type:Table tables,Bool queryCacheable:=true):super(db,tables){
    if(queryCacheable){
      this.queryCache=Cache()
    }
  }
  
  Void clearCache(){
    getCache.clearAll
    queryCache?.clearAll
  }
  
  ////////////////////////////////////////////////////////////////////////
  //cache method
  ////////////////////////////////////////////////////////////////////////
  
  private const static Str tcache:="slandao.CacheContext.tcache"
  
  private Cache getCache(){
    return Actor.locals[tcache]?:cache
  }
  
  private Void set(Str key,Obj? value){ getCache[key]=value }
  
  private Obj? get(Str key){
    if(log.isDebug){
        log.debug("using cache:[$key]".replace("\n",""))
    }
    return getCache[key]
  }
  
  private Bool containsKey(Str key){ getCache.containsKey(key) }
  
  Void removeCache(Str key){ getCache.remove(key)}
  
  ////////////////////////////////////////////////////////////////////////
  //query cache
  ////////////////////////////////////////////////////////////////////////
  
  private Bool usingQueryCache(){
    return queryCache!=null && Actor.locals[tcache]==null//not in transcation
  }
  
  private Obj? queryGet(Str key){
    if(log.isDebug){
        log.debug("using queryCache:[$key]".replace("\n",""))
    }
    return queryCache[key]
  }
  
  Void clearQueryCache(Type type){
    if(queryCache==null)return
    
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
    queryCache.set(key,ids,1min)
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
    queryCache.set(key,ids,1min)
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
    queryCache.set(key,n,1min)
    return n
  }
  
  ////////////////////////////////////////////////////////////////////////
  //transaction
  ////////////////////////////////////////////////////////////////////////
  
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
  
  private Void commitCaheTrans(){
    cache.mergeCache(getCache.getMap)
  }
}
