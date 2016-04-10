//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2011-12-02  Jed Young  Creation
//


**
** record model
**
internal class User : ObjRecord
{
  const static TableDef table := ObjTableDef(User#)

  new make() : super(table) {}

  @Id
  @Colu { name = "sid" }
  Int? id
  Str? name
  Int? age
  Float? weight
  Buf? image
}

