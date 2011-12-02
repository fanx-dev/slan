//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

using slanData

internal class InsertMakerTest : Test
{
  InsertMaker maker := InsertMaker()

  Void testGetSql()
  {
    Schema table := StudentTable.getTable

    sql := maker.getSql(table)
    echo(sql)
  }

  Void testGetParam()
  {
    Schema table := StudentTable.getTable
    stu := Student
    {
      name = "yjd"
      age = 23
      married = false
      weight = 55f
      dt = DateTime.now
    }
    param := maker.getParam(table, stu)
    echo(param)
    verifyEq(param.size, 6)
    verifyEq(param[1], "yjd")
    verifyEq(param[2], false)
    verifyEq(param[3], 23)
  }
}