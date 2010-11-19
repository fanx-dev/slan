//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

using isql

**
** as a database column.
** override getSqlType for dialect,
** this is just for mysql.
**
** column name default is parent type name +  field name
**
const class Column
{
  const Field field
  const Str name
  const SlanDialect dialect

  //ext parameter
  ** first parameter
  const Int? m

  ** second parameter
  const Int? d

  ** field type is primitive ,like Int,Float,Str,DateTime...
  const Bool isPrimitive

  private static const Log log := Column#.typeof.pod.log

  new make(Field field, SlanDialect dialect, Str? name := null, Int? m := null, Int? d := null)
  {
    this.field = field
    this.dialect = dialect
    this.name = name ?: field.parent.name +"_"+ field.name
    this.m = m
    this.d = d

    //check,field must be primitiveType or Serializable
    isPrimitive = isPrimitiveType(field.type)
    if (!isPrimitive)
    {
      if (!field.type.hasFacet(Serializable#))
      {
        log.warn("field $field.name must be primitiveType or Serializable.
                          please using @Transient for Ignore")
      }
    }
  }

  **
  ** get sql type for create table
  **
  virtual Str getSqlType(Bool autoGenerate := false)
  {
    if (isPrimitive)
    {
      return fanToSqlType(field.type, autoGenerate)
    }
    if (field.type.isEnum) return smallInteger

    //it will be a serialization string type
    return getStringType(1024)
  }

  **
  ** convert from fantom type to sql type
  **
  private Str fanToSqlType(Type type, Bool autoGenerate)
  {
    if (autoGenerate) return dialect.identity

    Str t := ""
    switch(type.toNonNullable)
    {
      case Int#:
        t = dialect.bigInt
      case Str#:
        t = getStringType(m)
      case Float#:
        t = dialect.float
      case Bool#:
        t = dialect.bool
      case DateTime#:
        t = dialect.datetime
      case Date#:
        t = dialect.date
      case Time#:
        t = dialect.time
      case Decimal#:
        t = dialect.decimal
      default:
        throw MappingErr("unknown sql type $type,
                          please using @Transient for Ignore")
    }
    return t
  }

  private Str getStringType(Int? m){
    return m == null ? dialect.string() : dialect.string(m)
  }
  private Str smallInteger(){ dialect.smallInt }


  private Bool isPrimitiveType(Type type)
  {
    Utils.isPrimitiveType(type)
  }

  ** to saveable primitive
  Obj? getValue(Obj obj)
  {
    value := field.get(obj)

    if (value == null) return null
    if (isPrimitive) return value

    if (field.type.isEnum)
    {
      return (value as Enum)?.ordinal
    }

    //serialization
    sb := StrBuf()
    sb.out.writeObj(value)
    return sb.toStr
  }

  ** restore object
  Void setValue(Obj obj, Obj? value)
  {
    Obj? nvalue
    if (value == null)
    {
      nvalue = null
    }
    else if (isPrimitive)
    {
      nvalue = value
    }
    else if (field.type.isEnum)
    {
      Enum[] vals := field.type.field("vals").get
      nvalue = vals.get(value)
    }
    else
    {
      nvalue = value.toStr.in.readObj()
    }
    echo("Column#setValue $obj,${field.name},$nvalue")
    field.set(obj,nvalue)
  }

  ** check the column is match the database
  Bool checkMatchDb(Col c)
  {
    if (c.name != name) return false
    if (isPrimitive)
    {
      return c.type.qname == field.type.qname
    }
    if (field.type.isEnum)
    {
      return c.type.qname == Int#.qname
    }
    return c.type.qname == Str#.qname
  }
}