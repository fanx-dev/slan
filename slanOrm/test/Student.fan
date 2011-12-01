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
      Column(Student#sid, dialect, 0, "sid"),
      Column(Student#name, dialect, 1, "name"),
      Column(Student#married, dialect, 2, "married"),
      Column(Student#age, dialect, 3, "age"),
      Column(Student#weight, dialect, 4, "weight"),
      Column(Student#dt, dialect, 5, "dt")
    }
    t := Table
    (
      Student#,
      "Student",
      cs,
      0
    )
    return t
  }
}

