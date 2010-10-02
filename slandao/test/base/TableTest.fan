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
    t:=Table.createFromType(Student#,SlanDialect())
    verify(t.id.name=="sid")
    verifyEq(t.columns.size,8)
  }
}
