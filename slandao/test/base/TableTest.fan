//
// Copyright (c) 2010, Yang Jiandong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Yang Jiandong  Creation
//
internal class TableTest:Test
{
  Void testcreateFromType(){
    t:=Table.mappingFromType(Student#,MysqlDialect())
    verify(t.id.name=="StudentSid")
    verifyEq(t.columns.size,9)
  }
}
