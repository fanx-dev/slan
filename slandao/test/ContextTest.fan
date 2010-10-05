//
// Copyright (c) 2010 Yang Jiandong
// Licensed under Eclipse Public License version 1.0
//
// History:
//   yangjiandong 2010-10-5 - Initial Contribution
//


**
**
**
internal class ContextTest : TestBase
{
  Void testCheck(){
    execute|->|{
      pass:=c.checkTable(c.getTable(Student#))
      verify(pass)
    }
  }
}
