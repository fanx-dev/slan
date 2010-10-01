//
// Copyright (c) 2010, Yang Jiandong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Yang Jiandong  Creation
//
const class Column
{
  const Field field
  const Str name
  private const Str? sqlType
  
  new make(Field field,Str? name:=null,Str? sqlType:=null){
    this.field=field
    this.name=name?:field.name
    this.sqlType=sqlType
  }
  
//  virtual Str getFieldStr(Obj obj){
//    o:=field.get(obj)
//    
//    if (o == null)     return "null"
//    if (o is Str)      return "'$o'"
//    if (o is DateTime) return "'" + o->toLocale("YYYY-MM-DD hh:mm:ss") + "'"
//    if (o is Date)     return "'" + o->toLocale("YYYY-MM-DD") + "'"
//    if (o is Time)     return "'" + o->toLocale("hh:mm:ss") + "'"
//    return o.toStr
//  }
  
  virtual Str getSqlType(Bool autoGenerate:=false){
    if(sqlType!=null)return sqlType
    
    qname:=field.type.qname
    Str type:=""
    if(qname==Int#.qname)         type= "int"
    else if(qname==Str#.qname)    type= "varchar(255)"
    else if(qname==Float#.qname)  type= "double"
    else if(qname==Bool#.qname)   type= "bit"
    else if(qname==DateTime#.qname) type= "datetime"
    else if(qname==Date#.qname)   type= "date"
    else if(qname==Time#.qname)   type= "time"
    else if(field.type.isEnum )   type= "int"
    else                          type= field.type.name
    
    if(autoGenerate){
      type+=" auto_increment"
    }
    return type
  }
  
  virtual Obj? getValue(Obj obj){
    if(field.type.isEnum){
      return (field.get(obj) as Enum)?.ordinal
    }
    return field.get(obj)
  }
  
  virtual Void setValue(Obj obj,Obj? value){
    if(field.type.isEnum && value!=null){
      Enum[] vals:=field.type.field("vals").get
      echo("$vals")
      enu:=vals[value]
      field.set(obj,enu)
    }else{
      field.set(obj,value)
    }
  }
}
