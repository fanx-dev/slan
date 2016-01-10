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
facet class Colu
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
** Table is a metadata of records
**
@Js
@Serializable
const class ObjTable : Table
{
  const Field[] fields := [,]

  new make(Type type) : super.make(|Table t| {
     cfList := Column[,]
     fList := Field[,]
     type.fields.each |f, i| {
       initFeild(cfList, fList, f, i)

       if (f.hasFacet(Id#)) {
         Id id := f.facet(Id#)
         t.idIndex = cfList.size-1
         if (id.autoGenId == null) {
           t.autoGenerateId = f.type.toNonNullable == Int#
         } else {
           t.autoGenerateId = id.autoGenId
         }
       }
     }
     t.columns = cfList
     t.type = type
     t.name = type.name
  }) {
     fList := Field[,]
     type.fields.each |f, i| {
       if (f.isStatic || f.isSynthetic || f.hasFacet(Transient#)) {
       } else {
         fList.add(f)
       }
     }
     this.fields = fList
  }

  private Void initFeild(Column[] cfList, Field[] fList, Field f, Int i) {
     if (f.isStatic || f.isSynthetic || f.hasFacet(Transient#)) {
     }
     else if (f.hasFacet(Colu#)) {
       Colu c := f.facet(Colu#)
       cf := Column {
          it.name = c.name
          it.type = f.type
          it.sqlType = c.sqlType
          it.length = c.length
          it.precision = c.precision
          it.indexed = c.indexed
          it.index = cfList.size
       }
       cfList.add(cf)
       fList.add(f)
     }
     else {
       cf := Column {
          it.name = f.name
          it.type = f.type
          it.index = cfList.size
       }
       cfList.add(cf)
       fList.add(f)
     }
  }
}

@Js
@Serializable
class ObjRecord : Record
{
  @Transient
  override Table schema

  new make(Table s) {
    schema = s
  }

  override Obj? get(Int i) {
    obj := (schema as ObjTable).fields[i].get(this)
    if (obj is Enum) {
      return (obj as Enum).ordinal
    }
    return obj
  }

  override Void set(Int i, Obj? value) {
    field := (schema as ObjTable).fields[i]
    if (field.type.isEnum && value is Int) {
      value = field.type.field("vals").get->get(value)
    }
    field.set(this, value)
  }
}