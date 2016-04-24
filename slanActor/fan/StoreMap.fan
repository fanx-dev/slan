//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

using concurrent

**
** singleton map
**
const class StoreMap
{
  private const Actor actor := Actor(ActorPool()) |Obj?[] arg->Obj?| {return receive(arg)}

  private Obj? receive(Obj?[] arg)
  {
    Str op := arg[0]
    switch(op)
    {
      case "get":
        return Actor.locals[arg[1]]
      case "set":
        Actor.locals[arg[1]] = arg[2]
      case "remove":
        return Actor.locals.remove(arg[1])
      case "clear":
        Actor.locals.clear
      default:
        throw Err("unreachable code")
    }
    return null;
  }

  @Operator
  Obj? get(Str key) { actor.send(["get",key].toImmutable).get }

  @Operator
  Void set(Str key,Obj val) { actor.send(["set",key,val].toImmutable) }

  Void remove(Str key) { actor.send(["remove",key].toImmutable) }

  Void clear() { actor.send(["clear"].toImmutable) }
}