//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

using slanData

internal class UpdateMakerTest : Test
{
  UpdateMaker maker := UpdateMaker()

  Void testGetSql()
  {
    Schema table := StudentTable.getTable
    stu := Student
    {
      name = "yjd"
      married = false
      weight = 55f
      dt = DateTime.now
    }
    sql := maker.getSql(table, stu)
    echo(sql)
  }

  Void testGetParam()
  {
    Schema table := StudentTable.getTable
    stu := Student
    {
      sid = 123
      name = "yjd"
      married = false
      weight = 55f
      dt = DateTime.now
    }
    param := maker.getParam(table, stu)
    stu.age = 23
    param = maker.getParam(table, stu)
    echo(param)

    verify(param.size == 6)
    verify(param[0] == "yjd")
    verify(param[1] == false)
    verifyEq(param[2], 23)
  }
}