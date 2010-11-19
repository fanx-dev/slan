//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//


const class H2Dialect : SlanDialect
{
  override Str string(Int m := 255)
  {
    if (m > 255)
    {
      return "CLOB"
    }
    else
    {
      return super.string(m)
    }
  }

  override Str datetime(){ "timestamp" }
}