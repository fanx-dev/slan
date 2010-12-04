//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

internal class CacheTest : Test
{

  Void testGet()
  {
    cache := SingletonMap()
    cache["key"] = "obj"
    this.verify(cache["key"] == "obj")
  }

  Void testRemove()
  {
    cache := SingletonMap()
    cache["key"] = "obj"
    cache.remove("key")
    this.verify(cache["key"] == null)
  }
}