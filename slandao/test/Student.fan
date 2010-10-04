//
// Copyright (c) 2010, Yang Jiandong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Yang Jiandong  Creation
//
**
** test model
**
@Serializable
internal class Student:Record
{
  @Id{auto=true} 
  Int? sid
  
  Str? name
  Bool? married
  Int? age
  Float? weight
  DateTime? dt
  @Transient Bool? large
  
  @Colu{m=256}
  Str? description
  
  Weekday? loveWeek
  
  @Transient override Context c:=TestContext.c
}
**************************************************************************
** for test
** 
internal class StudentTable
{
  static Table getTable(){
    cs:=Column[,]{
      Column(Student#sid),
      Column(Student#name),
      Column(Student#married),
      Column(Student#age),
      Column(Student#weight),
      Column(Student#dt)
    }
    t:=Table{
      type=Student#
      columns=cs
      it.idIndex=0
    }
    return t
  }
}

