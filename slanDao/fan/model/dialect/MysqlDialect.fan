//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//


**
**
**
const class MysqlDialect : SlanDialect
{
  override Str bool()
  {
    return "bit"
  }

  override Str identity(){ "bigint auto_increment" }
}