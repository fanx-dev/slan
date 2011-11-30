//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2011-11-27  Jed Young  Creation
//

using concurrent

**
** StoreMap Test
**
class StoreMapTest : Test
{
  Void test()
  {
    map := StoreMap()
    map["k"] = "v"
    v := map["k"]

    verifyEq(v, "v")

    map.remove("k")
    verifyNull(map["k"])

    map["k1"] = "v1"
    map.clear

    verifyNull(map["k1"]);
  }
}