//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

**
**
**
class LimitQueryTest : NewTestBase
{
  Void testLimit()
  {
    ps := Student{}.list("", 0, 3)
    verifyEq(ps.size, 3)
  }
  
  Void testLimitAndOffset()
  {
    ps := Student{}.list("", 2, 10)
    verifyEq(ps.size, 2)
  }
  
  Void testOffset()
  {
    Student? ps := Student{}.one("", 1)
    verifyEq(ps.name, "yjd2")
  }
}
