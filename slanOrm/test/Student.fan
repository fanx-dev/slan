//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

using slanData

**
** test model
**
@Persistent
@Serializable
internal class Student : Entity
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
  static Schema getTable()
  {
    dialect := MysqlDialect()
    cs := CField[,]
    {
      OField(Student#sid, 0, "sid"),
      OField(Student#name, 1, "name"),
      OField(Student#married, 2, "married"),
      OField(Student#age, 3, "age"),
      OField(Student#weight, 4, "weight"),
      OField(Student#dt, 5, "dt")
    }
    t := OSchema
    (
      Student#,
      "Student",
      cs,
      0
    )
    return t
  }
}

