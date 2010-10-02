//
// Copyright (c) 2010, Yang Jiandong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Yang Jiandong  Creation
//
internal class WhereMakerTest:Test
{
  WhereMaker maker:=WhereMaker()
  
  Void testGetSql(){
    Table table:=StudentTable.getTable
    stu:=Student{
      name="yjd"
      age=23
      married=false
      weight=55f
    }
    sql:=maker.getSql(table,stu)
    echo(sql)
  }
  
  Void testGetParam(){
    Table table:=StudentTable.getTable
    stu:=Student{
      name="yjd"
      age=23
      married=false
      weight=55f
    }
    param:=maker.getParam(table,stu)
    echo(param)
    verify(param.size==4)
    verify(param["name"]=="yjd")
    verify(param["age"]==23)
    verifyEq(param["sid"],null)
  }
}
