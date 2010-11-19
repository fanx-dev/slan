//
// Copyright (c) 2010 Yang Jiandong
// Licensed under Eclipse Public License version 1.0
//
// History:
//   yangjiandong 2010-10-6 - Initial Contribution
//

const class PostgreSqlCol : Column
{
  new make(Field field,Str? name:=null,Int? m:=null,Int? d:=null):super(field,name,m,d){
  }
  ** convert from fantom type to sql type
  protected override Str fanToSqlType(Type type,Bool autoGenerate){
    if(autoGenerate) return "bigserial"
    
    Str t:=""
    switch(type.toNonNullable){
      case Int#:
        t= "bigint"
      case Str#:
        t= getStringType(m)
      case Float#:
        t= "double precision"
      case Bool#:
        t= "boolean"
      case DateTime#:
        t= "timestamp"
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

const class PostgreSqlDialect : SlanDialect
{
  override Column createColumn(Field field,Str? name:=null,Int? m:=null,Int? d:=null){
    return PostgreSqlCol(field,name,m,d)
  }
}
