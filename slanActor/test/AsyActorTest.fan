//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2011-11-27  Jed Young  Creation
//

using concurrent

**
** AsyActor Test
**
class AsyActorTest : Test
{
  Void test()
  {
    actor := MyAsyActor(ActorPool())
    s := actor->foo->get
    verifyEq(s, "foo")
  }
}

const class MyAsyActor : AsyActor
{
  new make(ActorPool pool) : super(pool)
  {
  }

  Str _foo()
  {
    echo("hi")
    return "foo"
  }
}