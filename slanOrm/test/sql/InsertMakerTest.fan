//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

internal class InsertMakerTest : Test
{
  InsertMaker maker := InsertMaker()
  
  Void testGetSql()
  {
    Table table := StudentTable.getTable
    
    sql := maker.getSql(table)
    echo(sql)
  }
  
  Void testGetParam()
  {
    Table table := StudentTable.getTable
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
    verify(param.size == 6)
    verify(param["name"] == "yjd")
    verify(param["age"] == 23)
    verify(param["sid"] == null)
  }
}
