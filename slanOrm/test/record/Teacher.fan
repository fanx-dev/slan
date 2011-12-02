//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2011-12-02  Jed Young  Creation
//

using slanData

**
** Teacher record model
**
internal class Teacher
{
  Record r

  new make(Record r) { this.r = r }

  static Schema getSchema()
  {
    id := CField("sid", Int#, 0)
    name := CField("name", Str#, 1)
    age := CField("age", Int#, 2)
    weight := CField("weight", Float#, 3)
    image := CField("image", Buf#, 4)

    return Schema("Teacher", [id, name, age, weight, image], 0, true)
  }

  Int? id          { get { r.get(0) } set { r.set(0, it) } }
  Str? name        { get { r.get(1) } set { r.set(1, it) } }
  Int? age         { get { r.get(2) } set { r.set(2, it) } }
  Float? weight    { get { r.get(3) } set { r.set(3, it) } }
  Buf? image       { get { r.get(4) } set { r.set(4, it) } }
}