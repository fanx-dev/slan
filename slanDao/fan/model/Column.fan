//
// Copyright (c) 2010, Yang Jiandong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Yang Jiandong  Creation
//
using sql
**
** as a database column.
** override getSqlType for dialect,
** this is just for mysql.
** 
** column name default is parent type name +  field name
** 
const abstract class Column
{
  const Field field
  const Str name
  
  //ext parameter
  ** first parameter
  const Int? m
  ** second parameter
  const Int? d
  ** field type is primitive ,like Int,Float,Str,DateTime...
  const Bool isPrimitive
  
  private static const Log log:=Column#.typeof.pod.log
  
  new make(Field field,Str? name:=null,Int? m:=null,Int? d:=null){
    this.field=field
    this.name=name?:field.parent.name+field.name.capitalize
    this.m=m
    this.d=d
    
    //check,field must be primitiveType or Serializable
    isPrimitive=isPrimitiveType(field.type)
    if(!isPrimitive){
      if(!field.type.hasFacet(Serializable#)){
        log.warn("field $field.name must be primitiveType or Serializable.
                          please using @Transient for Ignore")
      }
    }
  }
  
  **
  ** get sql type for create table
  ** 
  virtual Str getSqlType(Bool autoGenerate:=false){
    if(isPrimitive){
      return fanToSqlType(field.type,autoGenerate)
    }
    if(field.type.isEnum) return smallInteger
    
    //it will be a serialization string type
    return getStringType(1024)
  }
  
  ** convert from fantom type to sql type
  protected abstract Str fanToSqlType(Type type,Bool autoGenerate)
  protected abstract Str getStringType(Int? m)
  protected abstract Str smallInteger()
  
  
  private Bool isPrimitiveType(Type type){
    switch(type.toNonNullable){
      case Int#:
        return true
      case Str#:
        return true
      case Float#:
        return true
      case Bool#:
        return true
      case DateTime#:
        return true
      case Date#:
        return true
      case Time#:
        return true
      case Decimal#:
        return true
      default:
        return false
    }
  }
  
  ** to saveable primitive
  Obj? getValue(Obj obj){
    value:=field.get(obj)
    
    if(value==null) return null
    if(isPrimitive) return value
    
    if(field.type.isEnum){
      return (value as Enum)?.ordinal
    }
    
    //serialization
    sb:= StrBuf()
    sb.out.writeObj(value)
    return sb.toStr
  }
  
  ** restore object
  Void setValue(Obj obj,Obj? value){
    Obj? nvalue
    if(value==null){
      nvalue=null
    }else if(isPrimitive){
      nvalue=value
    }else if(field.type.isEnum){
      Enum[] vals:=field.type.field("vals").get
      nvalue=vals[value]
    }else{
      nvalue=value.toStr.in.readObj()
    }
    field.set(obj,nvalue)
  }
  
  ** check the column is match the database
  Bool checkMatchDb(Col c){
    if(c.name!=name) return false
    if(isPrimitive){
      return c.of.qname==field.type.qname
    }
    if(field.type.isEnum){
      return c.of.qname==Int#.qname
    }
    return c.of.qname==Str#.qname
  }
}
