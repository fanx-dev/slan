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
class MyTest:Test,MyContext
{
  override Void setup(){
    DbConnection.cur.c.refreshDatabase
  }
}
