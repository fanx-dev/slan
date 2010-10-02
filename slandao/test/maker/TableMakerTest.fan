//
// Copyright (c) 2010, Yang Jiandong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Yang Jiandong  Creation
//
internal class TableMakerTest:Test
{
  TableMaker maker:=TableMaker()
  Table table:=StudentTable.getTable
  
  Void testCreateTable(){
    sql:=maker.createTable(table)
    verifyEq(sql,"create table Student(sid int,name varchar(255),married bit,age int,weight double,dt datetime,primary key (sid))")
  }
  
  Void testDropTable(){
    sql:=maker.dropTable(table)
    verifyEq(sql,"drop table Student")
  }
}
