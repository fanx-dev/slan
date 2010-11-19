//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//


const class PostgreSqlDialect : SlanDialect
{
  override Str float(){ "double precision" }

  override Str identity(){ "bigserial" }

  override Str datetime(){ "timestamp" }
}

