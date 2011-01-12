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
internal class NewTestBase : Test, TestConnection
{
  Log log := Pod.of(this).log
  LogLevel defaultLevel := log.level

  override Void setup()
  {
    c.db.open
    c.refreshDatabase
    DataFixture.init
    log.level = LogLevel.debug

    verify(!c.db.isClosed)
  }

  override Void teardown()
  {
    log.level = defaultLevel
    c.db.close
  }
}