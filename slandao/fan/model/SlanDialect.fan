//
// Copyright (c) 2010 Yang Jiandong
// Licensed under Eclipse Public License version 1.0
//
// History:
//   yangjiandong 2010-9-30 - Initial Contribution
//


**
** decide whice type column to create.
** It's column factory
**
const abstract class SlanDialect
{
  abstract Column createColumn(Field field,Str? name:=null,Int? m:=null,Int? d:=null)
}
