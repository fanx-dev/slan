using concurrent

const class Cache
{
  private const Actor actor := Actor(ActorPool()) |Obj?[] arg->Obj?| {return receive(arg)}
  
  private Obj? receive(Obj?[] arg){
    Str op:=arg[0]
    switch(op){
      case "get":
      return Actor.locals[arg[1]]
      case "set":
      return Actor.locals[arg[1]]=arg[2]
      case "remove":
      return Actor.locals.remove(arg[1])
    }
    return null;
  }

  Obj? get(Str key) { actor.send(["get",key].toImmutable).get }
  Void set(Str key,Obj val) { actor.send(["set",key,val].toImmutable) }
  Void remove(Str key) {actor.send(["remove",key].toImmutable)}
}
