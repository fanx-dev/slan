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
internal class EnumAndSerializatTest:TestBase
{
  Void testEnum(){
    execute|->|{
      id:=Student{
        name="yjd"
        age=23
        married=false
        weight=55f
        dt=DateTime.now
        loveWeek=Weekday.sat
      }.insert.sid
    
      c.clearCache
      Student stu2:=Student{sid=id}.select.first
      verifyEq(stu2.loveWeek,Weekday.sat)
    }
  }
  
  Void testSerialization(){
    execute|->|{
      id:=Student{
        name="yjd"
        age=23
        married=false
        weight=55f
        dt=DateTime.now
        uri=`http://slandao`
      }.insert.sid
    
      c.clearCache
      Student stu2:=Student{sid=id}.select.first
      verifyEq(stu2.uri,`http://slandao`)
    }
  }
}
