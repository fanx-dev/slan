//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2011-12-02  Jed Young  Creation
//


**
** Teacher record model
**
/*
internal class Teacher : ArrayRecord
{
  new make(Schema s) : super(s) { }

  static Schema getSchema()
  {
    schema := Schema("Teacher", Teacher#)
    {
      CField("sid", Int#), CField("name", Str#), CField("age", Int#)
      , CField("weight", Float#), CField("image", Buf#);
      idIndex = 0;
      autoGenerateId = true;
    }
    return schema
  }

  Int? id          { get { super.get(0) } set { super.set(0, it) } }
  Str? name        { get { super.get(1) } set { super.set(1, it) } }
  Int? age         { get { super.get(2) } set { super.set(2, it) } }
  Float? weight    { get { super.get(3) } set { super.set(3, it) } }
  Buf? image       { get { super.get(4) } set { super.set(4, it) } }
}
*/

internal class Teacher : ObjRecord
{
  static Schema getSchema()
  {
    schema := ObjSchema(Teacher#)
    return schema
  }

  new make(Schema s) : super(s) { }

  @Id
  @Column { name = "sid" }
  Int? id
  Str? name
  Int? age
  Float? weight
  Buf? image
}

