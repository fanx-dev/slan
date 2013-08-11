//
// Copyright (c) 2007, John Sublett
// Licensed under the Academic Free License version 3.0
//
// History:
//   26 Dec 07  John Sublett  Creation
//   2011-11-5  Jed Young
//
package fan.isql;

import java.sql.*;
import java.util.HashMap;
import java.util.Iterator;
import fan.sys.*;
import fan.isql.Statement;
import fan.isql.ResultSet;

public class StatementPeer
{
  public static StatementPeer make(Statement fan)
  {
    return new StatementPeer();
  }

//////////////////////////////////////////////////////////////////////////
// Init
//////////////////////////////////////////////////////////////////////////

  public static Statement create(SqlConn conn, String sql, boolean prepare)
  {
    Statement statement = Statement.make();
    statement.peer.sql = sql;
    statement.peer.prepared = prepare;
    statement.peer.autoGenKeys = conn.peer.supportsGetGenKeys;
    try
    {
      statement.peer.createStatement(conn);
    }
    catch (SQLException ex)
    {
      throw SqlConnPeer.err(ex);
    }
    return statement;
  }

  private void createStatement(SqlConn conn)
    throws SQLException
  {
    if (prepared)
    {
      if (autoGenKeys)
        stmt = conn.peer.jconn.prepareStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS);
      else
        stmt = conn.peer.jconn.prepareStatement(sql);
    }
    else
      stmt = conn.peer.jconn.createStatement();
  }

//////////////////////////////////////////////////////////////////////////
// prepare
//////////////////////////////////////////////////////////////////////////

  /**
   * Set the parameters for the underlying prepared statement
   * using the values specified in the map.
   */
  public Statement set(Statement self, long i, Object val)
  {
    if (!prepared)
      throw SqlErr.make("Statement has not been prepared.");
    PreparedStatement pstmt = (PreparedStatement)stmt;
    Object jobj = SqlUtil.fanToSqlObj(val);

    try
    {
      pstmt.setObject((int)i+1, jobj);
      return self;
    }
    catch (SQLException ex)
    {
      throw SqlConnPeer.err(ex);
    }
  }

///////////////////////////////////////////////////////////
// Batch
///////////////////////////////////////////////////////////

  public Statement addBatch(Statement self)
  {
    try
    {
      if (prepared)
        ((PreparedStatement)stmt).addBatch();
      else
        stmt.addBatch(sql);
    }
    catch (SQLException ex)
    {
      throw SqlConnPeer.err(ex);
    }
    return self;
  }

  public void executeBatch(Statement self)
  {
    try
    {
      stmt.executeBatch();
    }
    catch (SQLException ex)
    {
      throw SqlConnPeer.err(ex);
    }
  }

//////////////////////////////////////////////////////////////////////////
// Execute
//////////////////////////////////////////////////////////////////////////

  public ResultSet query(Statement self)
  {
    java.sql.ResultSet rs = null;
    try
    {
      if (prepared)
      {
        rs = ((PreparedStatement)stmt).executeQuery();
      }
      else
      {
        rs = stmt.executeQuery(sql);
      }

      ResultSet set = ResultSet.make();
      set.peer.init(rs);
      return set;
    }
    catch (SQLException ex)
    {
      throw SqlConnPeer.err(ex);
    }
  }

  public long execute(Statement self)
  {
    try
    {
      if (prepared)
      {
        return ((PreparedStatement)stmt).executeUpdate();
      }
      else
      {
        if (autoGenKeys)
          return stmt.executeUpdate(sql, java.sql.Statement.RETURN_GENERATED_KEYS);
        else
          return stmt.executeUpdate(sql);
      }
    }
    catch (SQLException ex)
    {
      throw SqlConnPeer.err(ex);
    }
  }

///////////////////////////////////////////////////////////
// Other
///////////////////////////////////////////////////////////

  public void close(Statement self)
  {
    try
    {
      stmt.close();
    }
    catch (SQLException ex)
    {
      throw SqlConnPeer.err(ex);
    }
  }

  public ResultSet getGeneratedKeys(Statement self)
  {
    ResultSet set = ResultSet.make();
    try
    {
      set.peer.init(stmt.getGeneratedKeys());
      return set;
    }
    catch (SQLException ex)
    {
      throw SqlConnPeer.err(ex);
    }
  }

///////////////////////////////////////////////////////////
// limit
///////////////////////////////////////////////////////////

  public Long limit(Statement self)
  {
    return limit <= 0 ? null : Long.valueOf(limit);
  }

  public void limit(Statement self, Long limit)
  {
    this.limit = 0;
    if (limit != null && limit.longValue() < Integer.MAX_VALUE)
      this.limit = limit.intValue();

    if (this.limit > 0)
    {
      try
      {
        stmt.setMaxRows(this.limit);
      }
      catch (SQLException ex)
      {
        throw SqlConnPeer.err(ex);
      }
    }
  }

  public Statement sql(Statement self, String sql)
  {
    this.sql = sql;
    return self;
  }

///////////////////////////////////////////////////////////
// Fields
///////////////////////////////////////////////////////////

  private boolean            prepared;
  private java.sql.Statement stmt;
  private String             sql;
  private int                limit = 0;
  private boolean            autoGenKeys = false;
}