//
// Copyright (c) 2010 Yang Jiandong
// Licensed under Eclipse Public License version 1.0
//
// History:
//   yangjiandong 2010-9-30 - Initial Contribution
//


**
**
**
const class SlanDialect
{
  virtual Column createColumn(Field field,Str? name:=null,Str? sqlType:=null){
    return Column(field,name,sqlType)
  }
}
