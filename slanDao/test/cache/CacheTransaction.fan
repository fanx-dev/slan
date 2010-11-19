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
internal class CacheTransaction : NewTestBase
{
  Void testErrorTransaction()
  {
    try
    {
      c.trans
      {
        Student{ sid = 1 }.list.first->delete
        verifyFalse(Student{ sid = 1 }.exist)
        throw Err("test transaction")
      }
    }catch{}
    verify(Student{ sid = 1 }.exist)
  }
  
  Void testSuccessTransaction()
  {
    c.trans
    {
      Student{ sid = 1 }.list.first->deleteByExample
      verifyFalse(Student{ sid = 1 }.exist)
    }
    verifyFalse(Student{ sid = 1 }.exist)
  }
}
