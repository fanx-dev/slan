//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

using slanData

internal class WhereMakerTest : Test
{
  WhereMaker maker := WhereMaker()

  Void testGetSql()
  {
    Schema table := StudentTable.getTable
    stu := Student
    {
      name = "yjd"
      age = 23
      married = false
      weight = 55f
    }
    sql := maker.getSql(table,stu)
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
    }
    param := maker.getParam(table, stu)
    echo(param)
    verify(param.size == 4)
    verify(param[0] == "yjd")
    verify(param[2] == 23)
  }
}