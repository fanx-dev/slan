//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

**
** decide whice type column to create.
** It's column factory
**
const abstract class SlanDialect
{
  virtual Str bigInt(){ "bigint" }
  virtual Str smallInt(){ "smallint" }

  virtual Str datetime(){ "datetime" }
  virtual Str date(){ "date" }
  virtual Str time(){ "time" }

  virtual Str bool(){ "boolean" }
  virtual Str identity(){ "identity"}

  virtual Str float(){ "double" }
  virtual Str decimal(){ "decimal" }

  virtual Str string(Int m := 255)
  {
    if (m <= 255)
    {
      return "varchar($m)"
    }
    else
    {
      return "text"
    }
  }

  virtual Str binary()
  {
    return "LONGVARBINARY"
  }
}