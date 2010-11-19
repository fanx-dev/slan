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
class QueryTest : NewTestBase
{
  Void testSelectAll()
  {
    n := Student{}.list.size
    verifyEq(n, 4)
  }

  Void testWhereAll()
  {
    Student[] stus := c.select(Student#, "")
    verifyEq(stus.size, 4)
  }

  Void testSelectOrderby()
  {
    Student s := Student{}.list("order by Student_age desc").first
    verifyEq(s.name, "yjd4")

    Student s2 := c.select(Student#, "order by Student_age desc").first
    verifyEq(s2.name, "yjd4")
  }
}