//
// Copyright (c) 2007, Brian Frank and Andy Frank
// Licensed under the Academic Free License version 3.0
//
// History:
//   2011-11-5  Jed Young
//
package fan.isql;

import java.sql.*;
import fan.sys.*;

public class DataSetPeer
{

//////////////////////////////////////////////////////////////////////////
// Peer Factory
//////////////////////////////////////////////////////////////////////////

  public static DataSetPeer make(DataSet fan)
  {
    return new DataSetPeer();
  }

  public void init(ResultSet rs) throws SQLException
  {
    this.jResultSet = rs;
    cols = makeCols(jResultSet);
    converters = makeConverters(jResultSet);
  }

//////////////////////////////////////////////////////////////////////////
// metadata
//////////////////////////////////////////////////////////////////////////

  public List cols(DataSet row)
  {
    return cols.list;
  }

  /**
   * Map result set columns to Fan columns.
   * result set.
   */
  private static Cols makeCols(ResultSet rs)
    throws SQLException
  {
    // map the meta-data to a dynamic type
    ResultSetMetaData meta = rs.getMetaData();
    int numCols = meta.getColumnCount();
    List cols = new List(SqlUtil.colType, numCols);
    for (int i=0; i<numCols; ++i)
    {
      String name = meta.getColumnLabel(i+1);
      String typeName = meta.getColumnTypeName(i+1);
      Type fanType = SqlUtil.sqlToFanType(meta.getColumnType(i+1));
      if (fanType == null)
      {
        System.out.println("WARNING: Cannot map " + typeName + " to Fan type");
        fanType = Sys.StrType;
      }
      cols.add(Col.make(Long.valueOf(i), name, fanType, typeName));
    }
    return new Cols(cols);
  }

  public Col col(DataSet row, String name) { return col(row, name, true); }
  public Col col(DataSet row, String name, boolean checked)
  {
    Col col = cols.get(name);
    if (col != null) return col;
    if (checked) throw ArgErr.make("Col not found: " + name);
    return null;
  }

//////////////////////////////////////////////////////////////////////////
// value
//////////////////////////////////////////////////////////////////////////

  public Object get(DataSet row, long col) throws SQLException
  {
    int i = (int)col;
    return converters[i].toObj(jResultSet, i+1);
  }

  /**
   * Make the list of converters for the specified result set.
   */
  private static SqlUtil.SqlToFan[] makeConverters(ResultSet rs)
    throws SQLException
  {
    int numCols = rs.getMetaData().getColumnCount();
    SqlUtil.SqlToFan[] converters = new SqlUtil.SqlToFan[numCols];
    for (int i=0; i<numCols; i++)
      converters[i] = SqlUtil.converter(rs, i+1);
    return converters;
  }

//////////////////////////////////////////////////////////////////////////
// Cursor
//////////////////////////////////////////////////////////////////////////

  public boolean next(DataSet row) throws SQLException
  {
    return jResultSet.next();
  }

  public boolean moveTo(DataSet row, long pos) throws SQLException
  {
    return jResultSet.absolute((int)pos);
  }

  public void close()
  {
    try
    {
      jResultSet.close();
    }
    catch (SQLException ex)
    {
      throw SqlConnPeer.err(ex);
    }
  }

//////////////////////////////////////////////////////////////////////////
// Fields
//////////////////////////////////////////////////////////////////////////

  private Cols cols;
  private SqlUtil.SqlToFan[] converters;
  private java.sql.ResultSet jResultSet;
}