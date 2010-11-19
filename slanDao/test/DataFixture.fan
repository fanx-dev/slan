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
class DataFixture
{
  static Void init()
  {
    Student
    {
      name = "yjd"
      age = 23
      married = false
      weight = 55f
      dt = DateTime.now
    }.insert
    
    Student
    {
      name = "yjd2"
      age = 24
      married = false
      weight = 56f
      dt = DateTime.now
    }.insert
    
    Student
    {
      name = "yjd3"
      age = 25
      married = true
      weight = 57f
      dt = DateTime.now
    }.insert
    
    Student
    {
      name = "yjd4"
      age = 26
      married = true
      weight = 58f
      dt = DateTime.now
    }.insert
  }
}
