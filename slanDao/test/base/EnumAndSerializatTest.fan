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
internal class EnumAndSerializatTest : NewTestBase
{
  override Void setup()
  {
    log.level = LogLevel.debug
    c.refreshDatabase
  }
  
  Void testEnum()
  {
    id := Student
    {
      name = "yjd"
      age = 23
      married = false
      weight = 55f
      dt = DateTime.now
      loveWeek = Weekday.sat
    }.insert.sid
  
    c.clearCache
    Student stu2 := Student{ sid = id }.one
    verifyEq(stu2.loveWeek, Weekday.sat)
  }
  
  Void testSerialization()
  {
    id := Student
    {
      name = "yjd"
      age = 23
      married = false
      weight = 55f
      dt = DateTime.now
      uri = [`http://slandao`]
    }.insert.sid
  
    c.clearCache
    Student stu2 := Student{ sid = id }.one
    verifyEq(stu2.uri, [`http://slandao`])
  }
}
