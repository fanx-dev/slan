//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

using isql
using concurrent
using [java]java.lang::Class

**
** Connection for test
**
internal class ConnFactoryTest : Test
{
  Void test()
  {
    factory := ConnFactory.make(TestConnection#.pod)
    context := factory.initFromDb(|Str name->Bool| { name.equalsIgnoreCase("STUDENT") })
  }
}