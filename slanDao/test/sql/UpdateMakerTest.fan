//
// Copyright (c) 2010, Yang Jiandong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Yang Jiandong  Creation
//
internal class UpdateMakerTest:Test
{
  UpdateMaker maker:=UpdateMaker()
  
  Void testGetSql(){
    Table table:=StudentTable.getTable
    stu:=Student{
      name="yjd"
      married=false
      weight=55f
      dt=DateTime.now
    }
    sql:=maker.getSql(table,stu)
    echo(sql)
  }
  
  Void testGetParam(){
    Table table:=StudentTable.getTable
    stu:=Student{
      sid=123
      name="yjd"
      married=false
      weight=55f
      dt=DateTime.now
    }
    param:=maker.getParam(table,stu)
    stu.age=23
    param=maker.getParam(table,stu)
    echo(param)
    
    verify(param.size==6)
    verify(param["name"]=="yjd")
    verify(param["age"]==23)
    verifyEq(param["sid"],123)
  }
}
