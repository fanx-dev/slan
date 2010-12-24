//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-12-24  Jed Young  Creation
//

using isql

**
** mappint sql resultSet to XML or JSON
**
const class DataService
{
  const SqlService db

  new make(SqlService db) { this.db = db }

  Obj execute(Str sql)
  {
    db.sql(sql).execute
  }

  Void sql(Str sql, OutStream out, Int offset := 0, Int limit := 20)
  {
    statement := db.sql(sql)
    statement.offset = offset
    statement.limit = limit
    rows := statement.query

    XmlMaker(rows).dump(out)
  }
}