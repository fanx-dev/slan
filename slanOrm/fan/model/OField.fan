//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

using slanData

**
** as a database column.
** override getSqlType for dialect,
** this is just for mysql.
**
** column name default is parent type name +  field name
**
const class OField : CField
{
  ** object field of the Entity
  private const Field field

  **
  ** if the name is null, will use field name
  **
  new makeNew(Field field, Int index, Str? name := null, |This|? f := null)
    : super.makeNew(name ?: field.parent.name + "_" + field.name, field.type, index, f)
  {
    this.field = field
  }

//////////////////////////////////////////////////////////////////////////
// Get/Set value
//////////////////////////////////////////////////////////////////////////

  ** to saveable primitive
  override Obj? get(Obj obj)
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
  override Void set(Obj obj, Obj? value)
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
    //echo("Column#setValue $obj,${field.name},$nvalue")
    field.set(obj,nvalue)
  }
}