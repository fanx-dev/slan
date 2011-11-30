//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2011-11-27  Jed Young  Creation
//

using concurrent

**
** ActorLocal Test
**
class ActorLocalTest : Test
{
  Void test()
  {
    local := ActorLocal()
    local.set("hi")

    verifyEq(local.get, "hi")
  }
}