//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

**
** test model
**
@Persistent
@Serializable
internal class Student : Record
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

  @Transient override Context context := TestConnection.c
}

**************************************************************************
** for test
**************************************************************************

internal class StudentTable
{
  static Table getTable()
  {
    dialect := MysqlDialect()
    cs := Column[,]
    {
      Column(Student#sid, dialect, "sid"),
      Column(Student#name, dialect, "name"),
      Column(Student#married, dialect, "married"),
      Column(Student#age, dialect, "age"),
      Column(Student#weight, dialect, "weight"),
      Column(Student#dt, dialect, "dt")
    }
    t := Table
    {
      type = Student#
      name = "Student"
      columns = cs
      it.idIndex = 0
    }
    return t
  }
}

