//
// Copyright (c) 2010 Yang Jiandong
// Licensed under Eclipse Public License version 1.0
//
// History:
//   yangjiandong 2010-9-30 - Initial Contribution
//


**
**
**
class EnumTest:TestBase
{
  Void test(){
    execute|->|{
      id:=Student{
      name="yjd"
      age=23
      married=false
      weight=55f
      dt=DateTime.now
      loveWeek=Weekday.sat
      }.insert.sid
    
      Student stu2:=Student{sid=id}.select.first
      verifyEq(stu2.loveWeek,Weekday.sat)
    }
  }
}
