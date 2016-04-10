//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//


const class SqlDialect {

  virtual Str autoIncrement() {
    return "AUTO_INCREMENT"
  }

  virtual Str escaptSqlWord(Str w) {
    return "`" + w +"`"
  }

  **
  ** get sql type for create table
  **
  virtual Str getSqlType(FieldDef f) {
    if (f.sqlType != null) {
      return f.sqlType
    }
    if (f.type.isEnum) return "smallint"
    return fanToSqlType(f)
  }

  **
  ** convert from fantom type to sql type
  **
  private Str fanToSqlType(FieldDef f)
  {
    Str t := ""
    switch(f.type.toNonNullable)
    {
      case Int#:
        t = "INTEGER"
      case Str#:
        m := f.length
        if (m == null) m = 64
        t = "VARCHAR($m)"
      case Float#:
        t = "DOUBLE"
      case Bool#:
        t = "BOOLEAN"
      case DateTime#:
        t = "DATETIME"
      case Date#:
        t = "DATE"
      case Time#:
        t = "TIME"
      case Decimal#:
        t = "DECIMAL"
      case Buf#:
        t = "BLOB"
      default:
        t = "TEXT"
    }
    return t
  }
}

const class MySqlDialect : SqlDialect {}

