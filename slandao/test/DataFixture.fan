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
class DataFixture
{
  static Void init(){
    Student{
      name="yjd"
      age=23
      married=false
      weight=55f
      dt=DateTime.now
    }.insert
    
    Student{
      name="yjd2"
      age=24
      married=false
      weight=56f
      dt=DateTime.now
    }.insert
    
    Student{
      name="yjd3"
      age=25
      married=true
      weight=57f
      dt=DateTime.now
    }.insert
    
    Student{
      name="yjd4"
      age=26
      married=true
      weight=58f
      dt=DateTime.now
    }.insert
  }
}
