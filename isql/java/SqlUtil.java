//
// Copyright (c) 2007, Brian Frank and Andy Frank
// Licensed under the Academic Free License version 3.0
//
// History:
//   01 Jul 07  Brian Frank  Creation
//
package fan.isql;

import java.sql.*;
import fan.sys.*;
import fanx.main.*;
import fan.std.*;
import fanx.interop.*;

public class SqlUtil
{

  /**
   * Type literal for sql::Col
   */
  public static final Type colType;
  static
  {
    Type t = null;
    try { t = Type.find("isql::Col"); }
    catch (Exception e) { e.printStackTrace(); }
    colType = t;
  }

  /**
   * Get a JDBC Java object for the specified Fan object.
   */
  public static Object fanToSqlObj(Object value)
  {
    Object jobj = value;

    if (value instanceof DateTime)
    {
      DateTime dt = (DateTime)value;
      jobj = new Timestamp(dt.toJava());
    }
    else if (value instanceof fan.std.Date)
    {
      fan.std.Date d = (fan.std.Date)value;
      jobj = new java.sql.Date((int)d.year()-1900, (int)d.month().ordinal(), (int)d.day());
    }
    else if (value instanceof fan.std.TimeOfDay)
    {
      fan.std.TimeOfDay t = (fan.std.TimeOfDay)value;
      jobj = new java.sql.Time((int)t.hour(), (int)t.min(), (int)t.sec());
    }
    else if (value instanceof MemBuf)
    {
      jobj = fanx.interop.Interop.toJavaByteArray((MemBuf)value);
    }

    return jobj;
  }

  public static final Type intType = Sys.findType("sys::Int");
  public static final Type floatType = Sys.findType("sys::Float");
  public static final Type boolType = Sys.findType("sys::Bool");
  public static final Type strType = Sys.findType("sys::Str");
  public static final Type decimalType = Sys.findType("std::Decimal");
  public static final Type bufType = Sys.findType("std::Buf");
  public static final Type dateTimeType = Sys.findType("std::DateTime");
  public static final Type timeOfDayType = Sys.findType("std::TimeOfDay");
  public static final Type dateType = Sys.findType("std::Date");

  /**
   * Map an java.sql.Types code to a Fan type.
   */
  public static Type sqlToFanType(int sql)
  {
    switch (sql)
    {
      case Types.CHAR:
      case Types.NCHAR:
      case Types.VARCHAR:
      case Types.NVARCHAR:
      case Types.LONGVARCHAR:
      case Types.CLOB:
        return intType;

      case Types.BIT:
      case Types.BOOLEAN:
        return boolType;

      case Types.TINYINT:
      case Types.SMALLINT:
      case Types.INTEGER:
      case Types.BIGINT:
        return intType;

      case Types.REAL:
      case Types.FLOAT:
      case Types.DOUBLE:
        return floatType;

      case Types.DECIMAL:
      case Types.NUMERIC:
        return decimalType;

      case Types.BINARY:
      case Types.VARBINARY:
      case Types.LONGVARBINARY:
      case Types.BLOB:
        return bufType;

      case Types.TIMESTAMP:
        return dateTimeType;

      case Types.DATE:
        return dateType;

      case Types.TIME:
        return timeOfDayType;

      default:
        return null;
    }
  }

//////////////////////////////////////////////////////////////////////////
// Sql => Fantom
//////////////////////////////////////////////////////////////////////////

  /**
   * Map an java.sql.ResultSet column to a Fantom object.
   */
  public static Object toObj(java.sql.ResultSet rs, int col)
    throws SQLException
  {
    switch (rs.getMetaData().getColumnType(col))
    {
      case Types.CHAR:
      case Types.VARCHAR:
      case Types.LONGVARCHAR:
      case Types.CLOB:
        return rs.getString(col);

      case Types.BIT:
      case Types.BOOLEAN:
        boolean b = rs.getBoolean(col);
        if (rs.wasNull()) return null;
        return Boolean.valueOf(b);

      case Types.TINYINT:
      case Types.SMALLINT:
      case Types.INTEGER:
      case Types.BIGINT:
        long i = rs.getLong(col);
        if (rs.wasNull()) return null;
        return Long.valueOf(i);

      case Types.REAL:
      case Types.FLOAT:
      case Types.DOUBLE:
        double f = rs.getDouble(col);
        if (rs.wasNull()) return null;
        return Double.valueOf(f);

      case Types.DECIMAL:
      case Types.NUMERIC:
        return rs.getBigDecimal(col);

      case Types.BINARY:
      case Types.VARBINARY:
      case Types.LONGVARBINARY:
      case Types.BLOB:
        byte[] buf = rs.getBytes(col);
        if (rs.wasNull()) return null;
        return Interop.toFanBuf(buf);

      default:
        return String.valueOf(rs.getObject(col));
    }
  }

  /**
   * Map an java.sql.ResultSet column to a Fantom object.
   */
  public static SqlToFan converter(java.sql.ResultSet rs, int col)
    throws SQLException
  {
    switch (rs.getMetaData().getColumnType(col))
    {
      case Types.CHAR:
      case Types.VARCHAR:
      case Types.LONGVARCHAR:
      case Types.CLOB:
        return new ToFanStr();

      case Types.BIT:
      case Types.BOOLEAN:
        return new ToFanBool();

      case Types.TINYINT:
      case Types.SMALLINT:
      case Types.INTEGER:
      case Types.BIGINT:
        return new ToFanInt();

      case Types.REAL:
      case Types.FLOAT:
      case Types.DOUBLE:
        return new ToFanFloat();

      case Types.DECIMAL:
      case Types.NUMERIC:
        return new ToFanDecimal();

      case Types.BINARY:
      case Types.VARBINARY:
      case Types.LONGVARBINARY:
      case Types.BLOB:
        return new ToFanBuf();

      case Types.TIMESTAMP:
        return new ToFanDateTime();

      case Types.DATE:
        return new ToFanDate();

      case Types.TIME:
        return new ToFanTime();

      default:
        return new ToDefFanStr();
    }
  }

//////////////////////////////////////////////////////////////////////////
// SqlToFan
//////////////////////////////////////////////////////////////////////////

  public abstract static class SqlToFan
  {
    public abstract Object toObj(java.sql.ResultSet rs, int col)
      throws SQLException;
  }

  public static class ToFanStr extends SqlToFan
  {
    public Object toObj(java.sql.ResultSet rs, int col)
      throws SQLException
    {
      return rs.getString(col);
    }
  }

  public static class ToFanBool extends SqlToFan
  {
    public Object toObj(java.sql.ResultSet rs, int col)
      throws SQLException
    {
      boolean b = rs.getBoolean(col);
      if (rs.wasNull()) return null;
      return Boolean.valueOf(b);
    }
  }

  public static class ToFanInt extends SqlToFan
  {
    public Object toObj(java.sql.ResultSet rs, int col)
      throws SQLException
    {
      long i = rs.getLong(col);
      if (rs.wasNull()) return null;
      return Long.valueOf(i);
    }
  }

  public static class ToFanFloat extends SqlToFan
  {
    public Object toObj(java.sql.ResultSet rs, int col)
      throws SQLException
    {
      double f = rs.getDouble(col);
      if (rs.wasNull()) return null;
      return Double.valueOf(f);
    }
  }

  public static class ToFanDecimal extends SqlToFan
  {
    public Object toObj(java.sql.ResultSet rs, int col)
      throws SQLException
    {
      return rs.getBigDecimal(col);
    }
  }

  public static class ToFanDateTime extends SqlToFan
  {
    public Object toObj(java.sql.ResultSet rs, int col)
      throws SQLException
    {
      java.sql.Timestamp ts = rs.getTimestamp(col);
      if (rs.wasNull()) return null;
      return DateTime.fromJava(ts.getTime());
    }
  }

  public static class ToFanDate extends SqlToFan
  {
    public Object toObj(java.sql.ResultSet rs, int col)
      throws SQLException
    {
      java.sql.Date d = rs.getDate(col);
      if (rs.wasNull()) return null;
      return fan.std.Date.make(d.getYear()+1900, (Month)Month.vals.get(d.getMonth()), d.getDate());
    }
  }

  public static class ToFanTime extends SqlToFan
  {
    public Object toObj(java.sql.ResultSet rs, int col)
      throws SQLException
    {
      java.sql.Time t = rs.getTime(col);
      if (rs.wasNull()) return null;
      return fan.std.TimeOfDay.make(t.getHours(), t.getMinutes(), t.getSeconds());
    }
  }

  public static class ToFanBuf extends SqlToFan
  {
    public Object toObj(java.sql.ResultSet rs, int col)
      throws SQLException
    {
      byte[] buf = rs.getBytes(col);
      if (rs.wasNull()) return null;
      return Interop.toFanBuf(buf);
    }
  }

  public static class ToDefFanStr extends SqlToFan
  {
    public Object toObj(java.sql.ResultSet rs, int col)
      throws SQLException
    {
      return String.valueOf(rs.getObject(col));
    }
  }

}