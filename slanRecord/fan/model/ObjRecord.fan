//
// Copyright (c) 2009-2016, chunquedong
//
// This file is part of ChunMap project
// Licensed under the GNU LESSER GENERAL PUBLIC LICENSE(Version >=3)
//
// History:
//   2016-01-01  Jed Young  Creation
//
@Js
facet class Column
{
  ** column name
  const Str name

  ** sql type. if null will use type
  const Str? sqlType

  ** first parameter
  const Int? length

  ** second parameter
  const Int? precision

  ** hint to build index on this field
  const Bool indexed := false
}

@Js
facet class Id {
  const Bool? autoGenId
}

**
** Schema is a metadata of records
**
@Js
@Serializable
class ObjSchema : Schema
{
  Field[] fields := [,]

  new make(Type type) : super.makeNew(type.name, type) {
    type.fields.each |f, i| {
       initFromField(f, i)
    }
  }

  private Void initFromField(Field f, Int i) {
     if (f.isStatic || f.isSynthetic || f.hasFacet(Transient#)) {
     }
     else if (f.hasFacet(Column#)) {
       Column c := f.facet(Column#)
       cf := CField {
          it.name = c.name
          it.type = f.type
          it.sqlType = c.sqlType
          it.length = c.length
          it.precision = c.precision
          it.indexed = c.indexed
       }
       add(cf)
       fields.add(f)
     }
     else {
       cf := CField {
          it.name = f.name
          it.type = f.type
       }
       add(cf)
       fields.add(f)
     }

     if (f.hasFacet(Id#)) {
       Id id := f.facet(Id#)
       idIndex = columns.size-1
       if (id.autoGenId == null) {
         autoGenerateId = f.type.toNonNullable == Int#
       } else {
         autoGenerateId = id.autoGenId
       }
     }
  }
}

@Js
@Serializable
class ObjRecord : Record
{
  @Transient
  override Schema schema

  new make(Schema s) {
    schema = s
  }

  override Obj? get(Int i) {
    (schema as ObjSchema).fields[i].get(this)
  }

  override Void set(Int i, Obj? value) {
    (schema as ObjSchema).fields[i].set(this, value)
  }
}