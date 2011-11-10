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
internal class ContextTest : NewTestBase
{
  Void testCheck()
  {
    pass := c.checkTable(c.getTable(Student#))
    verify(pass)
  }
}
