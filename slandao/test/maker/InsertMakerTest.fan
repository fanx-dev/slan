//
// Copyright (c) 2010, Yang Jiandong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Yang Jiandong  Creation
//
class InsertMakerTest:Test
{
  InsertMaker maker:=InsertMaker()
  
  Void testGetSql(){
    Table table:=StudentTable.getTable
    
    sql:=maker.getSql(table)
    echo(sql)
  }
  
  Void testGetParam(){
    Table table:=StudentTable.getTable
    stu:=Student{
      name="yjd"
      age=23
      married=false
      weight=55f
      dt=DateTime.now
    }
    param:=maker.getParam(table,stu)
    echo(param)
    verify(param.size==6)
    verify(param["name"]=="yjd")
    verify(param["age"]==23)
    verify(param["sid"]==null)
  }
}
