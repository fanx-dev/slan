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
    factory := ConnFactory.make(ConnFactoryTest#.pod)
    factory.open
    context := Context()
    mapping := Mapping(context.conn)
    mapping.each { echo(it.name) }
  }
}