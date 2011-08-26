//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2011-08-26  Jed Young  Creation
//

using concurrent

**
** ActorLocal
**
const class ActorLocal
{
  private const Str key := Uuid().toStr

  Obj? get() { Actor.locals[key] }
  Void set(Obj? obj) { Actor.locals[key] = obj }
}