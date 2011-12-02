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
internal mixin TestConnection
{
  static const CacheableContext c
  static const ConnFactory factory

  static
  {
    factory = ConnFactory.make(TestConnection#.pod)
    c = factory.initFromPod(TestConnection#.pod)
  }
}