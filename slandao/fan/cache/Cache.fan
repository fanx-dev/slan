using concurrent
**
** cache object and intime clearup
** 
const class Cache
{
  private const Actor actor := Actor(ActorPool()) |Obj?[] arg->Obj?| {return receive(arg)}
  private const Duration houseKeepingPeriod := 1min
  const Int maxNum
  const Duration rest
  private const static Str cachemap:="slandao.Cache.map"
  private const Log log:=Pod.of(this).log
  
  new make(Int maxNum:=10000,Duration rest:=10min){
    this.maxNum=maxNum
    this.rest=rest
    goOnHouseKeeping
  }
  
  private Obj? receive(Obj?[] arg){
    Str op:=arg[0]
    
    [Str:CacheObj]? map:=Actor.locals[cachemap]
    if(map==null)Actor.locals[cachemap]=map=Str:CacheObj[:]
    
    switch(op){
      case "get":
        obj:= map[arg[1]]
        if(obj==null)return null
        obj.lastAccess=Duration.now
        return obj
      
      case "set":
        return map[arg[1]]=arg[2]
      
      case "remove":
        return map.remove(arg[1])
      
      case "containsKey":
        return map.containsKey(arg[1])
      
      case "mergeCache":
        _mergeCache(arg[1],map)
      
      case "getmap":
        return map
      
      case "clearIf":
        _clearIf(map,arg[1])
      
      case "clearAll":
        return Actor.locals.remove(cachemap)
      
      case "_houseKeeping":
        houseKeeping(map)
    }
    return null;
  }
  
  
  private CacheObj? _get(Str key) { actor.send(["get",key]).get }
  private Void _set(Str key,CacheObj val) { actor.send(["set",key,val]) }
  private Void _remove(Str key) { actor.send(["remove",key]) }
  private Bool _containsKey(Str key) { actor.send(["containsKey",key]).get }
  
  [Str:CacheObj] getMap(){ actor.send(["getmap"]).get }
  
  Void clearAll(){ actor.send(["clearAll"])}
  Void clearIf(|Str->Bool| f){actor.send(["clearIf",f].toImmutable)}
  
  Obj? get(Str key) { 
    CacheObj? obj:=_get(key)
    return obj?.value
  }
  Void set(Str key,Obj? val,Duration expire_:=24hr){
    _set(key,CacheObj{id=key;value=val;expire=expire_})
  }
  Void remove(Str key) {
    _remove(key)
  }
  Bool containsKey(Str key) {
    _containsKey(key)
  }
  Void mergeCache([Str:CacheObj] source){ 
    actor.send(["mergeCache",source])
  }
  
  
  private Void _mergeCache([Str:CacheObj] source,[Str:CacheObj] target){
    source.each|CacheObj value,Str key|{
      target[key]=value
      if(log.isDebug){
        log.debug("commitCahe:[$key:$value]".replace("\n",""))
      }
    }
  }
  
  private Void _clearIf(Str:CacheObj? map,|Str->Bool| f){
    now := Duration.now
    old := map.findAll |CacheObj s,Str key->Bool|
    {
      f(key)
    }
    old.each |CacheObj s| { map.remove(s.id) }
  }
  
  ////////////////////////////////////////////////////////////////////////
  //houseKeeping
  ////////////////////////////////////////////////////////////////////////
  
  private Void houseKeeping(Str:CacheObj? map){
    dispose(map)
    if(map.size>maxNum){
      clear(map)
    }
    goOnHouseKeeping
  }
  
  private Void clear(Str:CacheObj? map){
    old:=CacheObj[,]
    i:=0
    map.find|CacheObj s->Bool|{
      old[i]=s
      i++
      return map.size-i<maxNum
    }
    old.each |CacheObj s| { map.remove(s.id) }
  }
  
  private Void dispose(Str:CacheObj? map){
    now := Duration.now
    old := map.findAll |CacheObj s->Bool|
    {
      isOld:= now - s.lastAccess > rest || now - s.createTime > s.expire
      return isOld
    }
    old.each |CacheObj s| { map.remove(s.id) }
  }
  
  private Void goOnHouseKeeping(){
    actor.sendLater(houseKeepingPeriod, "_houseKeeping")
  }
}
