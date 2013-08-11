//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

using isql


internal const class TableMaker
{
  const ColumnMaker column := ColumnMaker()

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

//////////////////////////////////////////////////////////////////////////
// Get SQL type string
//////////////////////////////////////////////////////////////////////////

  **
  ** get sql type for create table
  **
  virtual Str getSqlType(CField f, Bool autoGenerate := false)
  {
    if (f.sqlType != null)
    {
      return f.sqlType
    }
    if (f.type.isEnum) return "smallint"

    if (Utils.isPrimitiveType(f.type)) {
      return fanToSqlType(f, autoGenerate)
    }
    //it will be a serialization string type
    return getStringType(f.length ?: 1024)
  }

  **
  ** convert from fantom type to sql type
  **
  private Str fanToSqlType(CField f, Bool autoGenerate)
  {
    if (autoGenerate) return "identity"

    Str t := ""
    switch(f.type.toNonNullable)
    {
      case Int#:
        t = "bigint"
      case Str#:
        t = getStringType(f.length)
      case Float#:
        t = "double"
      case Bool#:
        t = "boolean"
      case DateTime#:
        t = "datetime"
      case Date#:
        t = "date"
      case Time#:
        t = "time"
      case Decimal#:
        t = "decimal"
      case Buf#:
        t = "LONGVARBINARY"
      default:
        throw MappingErr("unknown sql type $f.type,
                          please using @Transient for Ignore")
    }
    return t
  }

  private Str getStringType(Int? m)
  {
    if (m != null && m <= 255)
    {
      return "varchar($m)"
    }
    else
    {
      return "text"
    }
  }

}