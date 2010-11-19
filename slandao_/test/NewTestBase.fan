//
// Copyright (c) 2010 Yang Jiandong
// Licensed under Eclipse Public License version 1.0
//
// History:
//   yangjiandong 2010-10-7 - Initial Contribution
//


**
**
**
class NewTestBase : Test,TestConnection
{
  Log log:=Pod.of(this).log
  LogLevel defaultLevel:=log.level
  
  override Void setup(){
    c.refreshDatabase
    DataFixture.init
    log.level=LogLevel.debug
  }
  
  override Void teardown(){
    log.level=defaultLevel
  }
}
