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
@Persistent
@Serializable
internal class Student:Record
{
  @Id
  Int? sid
  
  Str? name
  Bool? married
  Int? age
  Float? weight
  DateTime? dt
  @Transient Bool? large
  
  @Colu{m=256}
  Str? description//text
  
  Weekday? loveWeek//enum
  Uri[]? uri//obj
  
  @Transient override Context context:=TestConnection.c
}
**************************************************************************
** for test
** 
internal class StudentTable
{
  static Table getTable(){
    cs:=Column[,]{
      MysqlCol(Student#sid,"sid"),
      MysqlCol(Student#name,"name"),
      MysqlCol(Student#married,"married"),
      MysqlCol(Student#age,"age"),
      MysqlCol(Student#weight,"weight"),
      MysqlCol(Student#dt,"dt")
    }
    t:=Table{
      type=Student#
      name="Student"
      columns=cs
      it.idIndex=0
    }
    return t
  }
}

