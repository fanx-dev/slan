//
// Copyright (c) 2011, Brian Frank and Andy Frank
// Licensed under the Academic Free License version 3.0
//
// History:
//   04 Jan 11  Brian Frank  Creation
//
package fan.isql;

import java.sql.*;
import fan.sys.*;
import fan.std.*;
import fanx.main.*;

public class SqlMetaPeer
{

//////////////////////////////////////////////////////////////////////////
// Peer Factory
//////////////////////////////////////////////////////////////////////////

  public static SqlMetaPeer make(SqlMeta fan)
  {
    return new SqlMetaPeer();
  }

//////////////////////////////////////////////////////////////////////////
// Versions
//////////////////////////////////////////////////////////////////////////

  public String productName(SqlMeta self)
  {
    try { return jmeta.getDatabaseProductName(); }
    catch(SQLException e) { throw err(e); }
  }

  public Version productVersion(SqlMeta self)
  {
    try { return ver(jmeta.getDatabaseMajorVersion(), jmeta.getDatabaseMinorVersion()); }
    catch(SQLException e) { throw err(e); }
  }

  public String productVersionStr(SqlMeta self)
  {
    try { return jmeta.getDatabaseProductVersion(); }
    catch(SQLException e) { throw err(e); }
  }

  public String driverName(SqlMeta self)
  {
    try { return jmeta.getDriverName(); }
    catch(SQLException e) { throw err(e); }
  }

  public Version driverVersion(SqlMeta self)
  {
    return ver(jmeta.getDriverMajorVersion(), jmeta.getDriverMinorVersion());
  }

  public String driverVersionStr(SqlMeta self)
  {
    try { return jmeta.getDriverVersion(); }
    catch(SQLException e) { throw err(e); }
  }

//////////////////////////////////////////////////////////////////////////
// Limits
//////////////////////////////////////////////////////////////////////////

  public Long maxColName(SqlMeta self)
  {
    try { return max(jmeta.getMaxColumnNameLength()); }
    catch(SQLException e) { throw err(e); }
  }

  public Long maxTableName(SqlMeta self)
  {
    try { return max(jmeta.getMaxTableNameLength()); }
    catch(SQLException e) { throw err(e); }
  }

//////////////////////////////////////////////////////////////////////////
// Tables
//////////////////////////////////////////////////////////////////////////

  public boolean tableExists(SqlMeta self, String tableName)
  {
    try
    {
      java.sql.ResultSet tables =
          jmeta.getTables(null,          // catalog
                          null,          // schema pattern
                          tableName.toUpperCase(),     // table name pattern
                          null);         // types

      boolean exists = tables.next();
      tables.close();
      return exists;
    }
    catch (SQLException ex)
    {
      throw err(ex);
    }
  }

  public List tables(SqlMeta self)
  {
    try
    {
      java.sql.ResultSet tables =
        jmeta.getTables(null,  // catalog
                        null,  // schema pattern
                        null,  // table name pattern
                        null); // types

      int nameIndex = tables.findColumn("TABLE_NAME");
      List tableList = List.make(32);
      while (tables.next())
      {
        String tableName = tables.getString(nameIndex);
        tableList.add(tableName);
      }
      tables.close();

      return tableList.ro();
    }
    catch (SQLException ex)
    {
      throw err(ex);
    }
  }

  public List tableMeta(SqlMeta self, String tableName)
  {
    try
    {
      java.sql.ResultSet columns = jmeta.getColumns(null, null, tableName.toUpperCase(), null);

      // map the meta-data to a dynamic type
      List cols = List.make(32);

      int nameIndex = columns.findColumn("COLUMN_NAME");
      int typeIndex = columns.findColumn("DATA_TYPE");
      int typeNameIndex = columns.findColumn("TYPE_NAME");
      int colIndex = 0;
      while (columns.next())
      {
        String name = columns.getString(nameIndex);
        String typeName = columns.getString(typeNameIndex);
        Type fanType = SqlUtil.sqlToFanType(columns.getInt(typeIndex));
        if (fanType == null)
        {
          System.out.println("WARNING: Cannot map " + typeName + " to Fan type");
          fanType = SqlUtil.strType;
        }
        cols.add(Col.make(Long.valueOf(colIndex++), name, fanType, typeName));
      }

      if (colIndex == 0)
        throw SqlErr.make("Table not found: " + tableName);

      return cols;
    }
    catch (SQLException ex)
    {
      throw err(ex);
    }
  }
//////////////////////////////////////////////////////////////////////////
// Utils
//////////////////////////////////////////////////////////////////////////

  static Long max(int limit)
  {
    if (limit <= 0) return null;
    return Long.valueOf(limit);
  }

  static Version ver(int major, int minor)
  {
    return Version.fromStr("" + major + "." + minor);
  }

  static RuntimeException err(SQLException e)
  {
    return SqlErr.make(e.getMessage(), Err.make(e));
  }

//////////////////////////////////////////////////////////////////////////
// Fields
//////////////////////////////////////////////////////////////////////////

  DatabaseMetaData jmeta;
}