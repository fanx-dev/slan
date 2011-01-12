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
internal class TransactionTest : NewTestBase
{
  Void testTransaction()
  {
    try
    {
      c.trans
      {
        Student{ sid = 1 }.one->delete
        verifyFalse(Student{ sid = 1 }.exist)
        throw Err("test transaction")
      }
    }
    catch{}

    verify(Student{ sid = 1 }.exist)
  }
}