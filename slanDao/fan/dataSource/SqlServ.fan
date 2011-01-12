//
// Copyright (c) 2008, John Sublett
// Licensed under the Academic Free License version 3.0
//
// History:
//   12 Jan 08  John Sublett  Creation
//
using sql
using concurrent

**
** SqlService is the interface to a relational database.  It is const
** and all state is stored as thread local variables.
**
const class SqlServ : Service
{
  **
  ** Make a new SqlService.
  **
  ** - 'connection' is the connection string.  For java this is the jdbc url.  For .NET
  **   this is the connection string.
  ** - 'username' is the username for the database login.
  ** - 'password' is the password for the database login.
  **
  new make(Str connection  := "",
           Str? username   := "",
           Str? password   := "")
  {
    pool = ConnectionPool(connection, username, password)
  }

  override Void onStart()
  {
    log.info("SqlService started [$pool.connectionStr]")
  }

  **
  ** Open the database.  This opens a connection to the database
  ** for the calling thread.  A database must be open before
  ** it can be accessed.  'open' may be called multiple times.
  ** Each time 'open' is called, a counter is incremented.  The
  ** database will not be closed until 'close' has been called
  ** for each call to 'open'.  Return this.
  **
  This open()
  {
    SqlConn? conn := Actor.locals[id]
    if (conn == null)
    {
      conn = pool.open()
      Actor.locals[id] = conn
    }
    else
    {
      //conn.increment
    }

    return this
  }

  **
  ** Get the connection to this database for the current thread.
  **
  private SqlConn? threadConnection(Bool checked := true)
  {
    SqlConn? conn := Actor.locals[id]
    if (conn == null)
    {
      if (checked)
        throw SqlErr("Database is not open.")
      else
        return null
    }

    if (conn.isClosed)
    {
      if (checked)
      {
        conn.close
        Actor.locals.remove(id)
        throw SqlErr("Database has been closed.")
      }
      else
        return null
    }

    return conn
  }

  **
  ** Close the database.  A call to 'close' may not actually
  ** close the database.  It depends on how many times 'open' has
  ** been called for the current thread.  The database will
  ** not be closed until 'close' has been called once for every time
  ** that 'open' has been called.
  **
  Void close()
  {
    SqlConn? conn := Actor.locals[id]
    if (conn != null)
    {
      //if (conn.decrement == 0)
      //{
        Actor.locals.remove(id)
        pool.close(conn)
      //}
    }
  }

  **
  ** Test the closed state of the database.
  **
  Bool isClosed()
  {
    conn := threadConnection(false)
    if (conn == null) return true
    return conn.isClosed
  }

  **
  ** close the connection pool
  **
  Void closePool(){
    pool.clear
  }

//////////////////////////////////////////////////////////////////////////
// Metadata
//////////////////////////////////////////////////////////////////////////

  **
  ** Does the specified table exist in the database?
  **
  Bool tableExists(Str tableName)
  {
    return threadConnection.meta.tableExists(tableName)
  }

  **
  ** List the tables in the database.  Returns a list of the
  ** table names.
  **
  Str[] tables()
  {
    return threadConnection.meta.tables();
  }

  **
  ** Get a default row instance for the specified table.  The
  ** result has a field for each table column.
  **
  Row tableRow(Str tableName)
  {
    return threadConnection.meta.tableRow(tableName)
  }

//////////////////////////////////////////////////////////////////////////
// Statement
//////////////////////////////////////////////////////////////////////////

  **
  ** Create a statement for this database.
  **
  Statement sql(Str sql)
  {
    return threadConnection.sql(sql)
  }

//////////////////////////////////////////////////////////////////////////
// Transactions
//////////////////////////////////////////////////////////////////////////

  **
  ** The auto-commit state of this database.  If true, each
  ** statement is committed as it is executed.  If false, statements
  ** are grouped into transactions and committed when 'commit'
  **
  Bool autoCommit
  {
    get { threadConnection.autoCommit }
    set { threadConnection.autoCommit = it }
  }

  **
  ** Commit all the changes made inside the current transaction.
  **
  Void commit()
  {
    threadConnection.commit
  }

  **
  ** Undo any changes made inside the current transaction.
  **
  Void rollback()
  {
    threadConnection.rollback
  }

//////////////////////////////////////////////////////////////////////////
// Fields
//////////////////////////////////////////////////////////////////////////

  ** Standard log for the sql service
  static const Log log := SqlServ#.pod.log

  **
  ** Unique identifier for VM used to key thread locals
  **
  private const ConnectionPool pool

  const Str id := SqlServ#.qname + ".conn"
}