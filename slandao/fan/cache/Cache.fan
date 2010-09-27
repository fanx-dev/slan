using concurrent

const class Cache
{
  private const Actor actor := Actor(ActorPool()) |Obj?[] arg->Obj?| {return receive(arg)}
  private const Duration houseKeepingPeriod := 1min
  const Int maxNum
  const Duration expire
  
  new make(Int maxNum:=10000,Duration expire:=1hr){
    this.maxNum=maxNum
    this.expire=expire
    goOnHouseKeeping
  }
  
  private Obj? receive(Obj?[] arg){
    Str op:=arg[0]
    
    [Str:CacheObj]? map:=Actor.locals["slandao.Cache.map"]
    if(map==null)Actor.locals["slandao.Cache.map"]=map=Str:CacheObj[:]
    
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
      
      case "_houseKeeping":
        houseKeeping(map)
    }
    return null;
  }
  
  
  private CacheObj? _get(Str key) { actor.send(["get",key]).get }
  private Void _set(Str key,CacheObj val) { actor.send(["set",key,val]) }
  private Void _remove(Str key) {actor.send(["remove",key])}
  
  
  Obj? get(Str key) { 
    CacheObj? obj:=_get(key)
    return obj?.value
  }
  Void set(Str key,Obj val){
    _set(key,CacheObj{id=key;value=val})
  }
  Void remove(Str key) {
    _remove(key)
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
      return now - s.lastAccess > expire
    }
    old.each |CacheObj s| { map.remove(s.id) }
  }
  
  private Void goOnHouseKeeping(){
    actor.sendLater(houseKeepingPeriod, "_houseKeeping")
  }
}
