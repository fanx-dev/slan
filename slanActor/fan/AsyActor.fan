//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2011-11-27  Jed Young  Creation
//

using concurrent

**
** Asynchronous Actor
** The method name start with "_", and call using '->'
**
**
const class AsyActor : Actor
{
  new make(ActorPool pool) : super(pool)
  {
  }

  protected override Obj? receive(Obj? msg)
  {
    Obj?[]? arg := msg
    Str name := "_"+arg[0]
    Obj?[]? args := arg[1]

    return this.trap(name, args)
  }

  override Obj? trap(Str name, Obj?[]? args := null)
  {
    if (name.startsWith("_"))
    {
      return super.trap(name, args)
    }
    else
    {
      return this.send([name, args].toImmutable)
    }
  }
}