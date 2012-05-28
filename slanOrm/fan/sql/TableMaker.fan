//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

using isql
using slanData


internal const class TableMaker
{
  const ColumnMaker column

  new make(Dialect dialect)
  {
    this.column = ColumnMaker(dialect)
  }

  Str createTable(Schema table)
  {
    sql := StrBuf()
    sql.add("create table $table.name(")

    table.each |CField c|
    {
      sqlType := column.getSqlType( c, table.autoGenerateId && table.id == c )
      sql.add("$c.name $sqlType,")
    }
    if (table.id != null)
    {
      sql.add("primary key ($table.id.name)")
    }
    sql.add(")")
    return sql.toStr
  }

  Str createIndex(Str tableName, Str fieldName)
  {
    "create index index_${tableName}_${fieldName} on ${tableName} (${fieldName})"
  }

  Str dropTable(Schema table)
  {
    return "drop table $table.name"
  }
}

**************************************************************************
**
**************************************************************************

internal const class ColumnMaker
{
  ** the database dialect of using
  const Dialect dialect

  new make(Dialect dialect)
  {
    this.dialect = dialect
  }

//////////////////////////////////////////////////////////////////////////
// Get SQL type string
//////////////////////////////////////////////////////////////////////////

  **
  ** get sql type for create table
  **
  virtual Str getSqlType(CField f, Bool autoGenerate := false)
  {
    if (f.isPrimitive)
    {
      return fanToSqlType(f, autoGenerate)
    }
    if (f.type.isEnum) return dialect.smallInt

    //it will be a serialization string type
    return getStringType(f.length ?: 1024)
  }

  **
  ** convert from fantom type to sql type
  **
  private Str fanToSqlType(CField f, Bool autoGenerate)
  {
    if (autoGenerate) return dialect.identity

    Str t := ""
    switch(f.type.toNonNullable)
    {
      case Int#:
        t = dialect.bigInt
      case Str#:
        t = getStringType(f.length)
      case Float#:
        t = dialect.float
      case Bool#:
        t = dialect.bool
      case DateTime#:
        t = dialect.datetime
      case Date#:
        t = dialect.date
      case Time#:
        t = dialect.time
      case Decimal#:
        t = dialect.decimal
      case Buf#:
        t = dialect.binary
      default:
        throw MappingErr("unknown sql type $f.type,
                          please using @Transient for Ignore")
    }
    return t
  }

  private Str getStringType(Int? m)
  {
    return m == null ? dialect.string() : dialect.string(m)
  }

}