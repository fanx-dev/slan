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
class Student:Record
{
  @Id{autoGenerate=true} 
  Int? sid
  
  Str? name
  Bool? married
  Int? age
  Float? weight
  DateTime? dt
  @Transient Bool? large
  
  @Colu{sqlType="text"}
  Str? description
  
  new make(){
    this.ct=TestContext.c
  }
}
**************************************************************************
class StudentTable
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

