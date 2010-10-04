//
// Copyright (c) 2010, Yang Jiandong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Yang Jiandong  Creation
//
**
** as a database column.
** override getSqlType for dialect,
** this is just for mysql
** 
const class Column
{
  const Field field
  const Str name
  
  //ext parameter
  const Int? m
  const Int? d
  
  new make(Field field,Str? name:=null,Int? m:=null,Int? d:=null){
    this.field=field
    this.name=name?:field.name
    this.m=m
    this.d=d
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
    
    qname:=field.type.qname
    Str type:=""
    if(qname==Int#.qname)         type= "int"
    
    //string type
    else if(qname==Str#.qname){
      if(m==null){
        type= "varchar(255)"
      }else{
        if(m<=255){
          type= "varchar($m)"
        }else{
          type= "text"
        }
      }
    }
    
    else if(qname==Float#.qname)  type= "double"
    else if(qname==Bool#.qname)   type= "bit"
    else if(qname==DateTime#.qname) type= "datetime"
    else if(qname==Date#.qname)   type= "date"
    else if(qname==Time#.qname)   type= "time"
    else if(field.type.isEnum )   type= "int"
    else{
      throw UnknownTypeErr("unknown sql type $qname,
                            please using @Transient for Ignore")
    }
    
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
      enu:=vals[value]
      field.set(obj,enu)
    }else{
      field.set(obj,value)
    }
  }
}
