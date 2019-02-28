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
  const Str? name

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
const class ObjTableDef : TableDef
{
  new make(Type type) : super.make(|TableDef t| {
     cfList := FieldDef[,]
     type.fields.each |f| {
       addFeild(cfList, f)

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
  }

  private static Void addFeild(FieldDef[] cfList, Field f) {
     if (f.isStatic || f.isSynthetic || f.hasFacet(Transient#)) {
     }
     else if (f.hasFacet(Colu#)) {
       Colu c := f.facet(Colu#)
       cf := FieldDef {
          it.name = c.name ?: f.name
          it.type = f.type
          it.sqlType = c.sqlType
          it.length = c.length
          it.precision = c.precision
          it.indexed = c.indexed
          it.index = cfList.size
          it.field = f
       }
       cfList.add(cf)
     }
     else {
       cf := FieldDef {
          it.name = f.name
          it.type = f.type
          it.index = cfList.size
          it.field = f
       }
       cfList.add(cf)
     }
  }
}
