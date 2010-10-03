//
// Copyright (c) 2010 Yang Jiandong
// Licensed under Eclipse Public License version 1.0
//
// History:
//   yangjiandong 2010-10-2 - Initial Contribution
//


**
**
**
class UserPoTest:Test,MyContext
{
  Void test(){
    Connection.cur.clearTables
    c.use{
      o:=UserPo{
        id="chunquedong"
        password="123"
        name="Jed"
        email="chunquedong@163.com"
        birthday=Date.fromStr("1987-10-21")
        role=Role.normal
      }.insert
      
      UserPo me:=UserPo{id="chunquedong"}.one
      
      verifyEq(me.name,"Jed")
    }
  }
}
