//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

internal class TableTest : Test
{
  Void testCreateFromType()
  {
    t := SqlUtil.mappingFromType(Student#, MysqlDialect())
    verify(t.id.name == "Student_sid")
    verifyEq(t.size, 9)
  }
}