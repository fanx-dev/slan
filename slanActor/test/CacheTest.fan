//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2011-11-27  Jed Young  Creation
//

using concurrent

**
** Cache Test
**
class CacheTest : Test
{
  Void test()
  {
    map := Cache()
    map["k"] = "v"
    v := map["k"]

    verifyEq(v, "v")

    map.remove("k")
    verifyNull(map["k"])

    map["k1"] = "v1"
    map.clear

    verifyNull(map["k1"]);
  }

  Void testCapacity()
  {
    Pod.of(this).log.level = LogLevel.debug

    map := Cache(2)
    map["k"] = "v"
    verifyEq(map["k"], "v")

    map["k1"] = "v1"
    map["k2"] = "v2"
    verifyEq(map["k2"], "v2")
    verifyEq(map["k"], null)
  }

  Void testClean()
  {
    Pod.of(this).log.level = LogLevel.debug

    map := Cache(2)
    map["k"] = "v"
    map["k1"] = "v1"
    map.get("k")
    map["k2"] = "v2"

    verifyEq(map["k"], "v")
    verifyEq(map["k2"], "v2")
    verifyEq(map["k1"], null)
  }
}