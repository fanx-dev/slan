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
    echo("*************************")
    init
    DataFixture.init
  }

  protected Void init()
  {
    log.level = LogLevel.debug
    factory.open
    c.rebuildDatabase
    verify(!c.conn.isClosed)
  }

  override Void teardown()
  {
    factory.close
    log.level = defaultLevel
  }
}