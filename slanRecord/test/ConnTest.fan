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
internal class ConnTest : Test
{
  Void test()
  {
    factory := ConnPool.makeConfig(ConnTest#.pod)
    context := factory.openContext

    mapping := Mapping(context.conn)
    mapping.each { echo(it.name) }

    context.close
  }
}