//
// Copyright (c) 2010 Yang Jiandong
// Licensed under Eclipse Public License version 1.0
//
// History:
//   yangjiandong 2010-10-6 - Initial Contribution
//


**
**
**
const class MysqlCol : Column
{
  new make(Field field,Str? name:=null,Int? m:=null,Int? d:=null):super(field,name,m,d){
  }
  ** convert from fantom type to sql type
  protected override Str fanToSqlType(Type type,Bool autoGenerate){
    Str t:=""
    switch(type.toNonNullable){
      case Int#:
        t= "bigint"
      case Str#:
        t= getStringType(m)
      case Float#:
        t= "double"
      case Bool#:
        t= "bit"
      case DateTime#:
        t= "datetime"
      case Date#:
        t= "date"
      case Time#:
        t= "time"
      case Decimal#:
        t= "decimal"
      default:
        throw MappingErr("unknown sql type $type,
                          please using @Transient for Ignore")
    }
    if(autoGenerate)t+=" auto_increment"
    return t
  }
  
  protected override Str getStringType(Int? m){
    if(m==null){
      return "varchar(255)"
    }else{
      if(m<=255){
        return "varchar($m)"
      }else{
        return "text"
      }
    }
  }
  
  protected override Str smallInteger(){
    return "smallint"
  }
}

**************************************************************************
** Dialect
**************************************************************************

const class MysqlDialect : SlanDialect
{
  override Column createColumn(Field field,Str? name:=null,Int? m:=null,Int? d:=null){
    return MysqlCol(field,name,m,d)
  }
}