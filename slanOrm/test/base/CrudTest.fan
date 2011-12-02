//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

**
** CRUD test
**
internal class CrudTest : NewTestBase
{
  override Void setup()
  {
    init
  }

  Void test()
  {
    this.insert
    this.select
    this.update
    this.delete
  }

  Void insert()
  {
    stu := Student
    {
      name = "yjd"
      age = 23
      married = false
      weight = 55f
      dt = DateTime.now
    }.insert
    verifyEq(stu.sid,1)

    stu2 := Student
    {
      name = "yqq"
      age = 24
      married = true
      weight = 55f
      dt = DateTime.now
    }.insert
    verifyEq(stu2.sid,2)
  }

  Void select()
  {
    n := Student{ weight = 55f }.list.size
    verifyEq(n,2)

    Student stu := Student{ sid = 1 }.one
    verifyEq(stu.name, "yjd")

    Student stu2 := c.findById(c.getTable(Student#), 2)
    verifyEq(stu2.name, "yqq")

    Student[] stus := c.select(c.getTable(Student#), "where Student_age>23")
    verifyEq(stus.size, 1)
  }

  Void update()
  {
    Student stu := Student{ sid = 1 }.one
    stu.married = true
    stu.update

    Student stu2:=Student{sid=1}.list.first
    verifyEq(stu2.married,true)
  }

  Void delete()
  {
    Student stu := Student{ sid = 1 }.one
    stu.deleteByExample

    exist := Student{ sid = 1 }.exist
    verifyEq(exist, false)
  }
}