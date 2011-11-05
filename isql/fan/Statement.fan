//
// Copyright (c) 2007, John Sublett
// Licensed under the Academic Free License version 3.0
//
// History:
//   21 Dec 07  John Sublett   Creation
//

**
** Statement is an executable statement for a specific database.
** A statement may be executed immediately or prepared and
** executed later with parameters.
** See [pod-doc]`pod-doc#statements`.
**
class Statement
{
  internal new make(){}
  **
  ** Make a new statement with the specified SQL text.
  **
  internal native static Statement create(SqlConn conn, Str sql, Bool prepare)


  **
  ** using it with try/catch
  **
  Void use(|This| f)
  {
    try
      f.call(this)
    finally
      this.close
  }

  **
  ** Set the sql
  **
  native This sql(Str sql)

///////////////////////////////////////////////////////////
// prepare
///////////////////////////////////////////////////////////

  **
  ** Prepare this statement by compiling for efficient
  ** execution.  Return this.
  **
  native This set(Int i, Obj? val)

///////////////////////////////////////////////////////////
// Batch
///////////////////////////////////////////////////////////

  **
  **
  **
  native This addBatch()
  native Void executeBatch()

///////////////////////////////////////////////////////////
// Other
///////////////////////////////////////////////////////////

  native DataSet getGeneratedKeys()

  **
  ** Close the statement.
  **
  native Void close()

  **
  ** Maximum number of rows returned when this statement is
  ** executed.  If limit is exceeded rows are silently dropped.
  ** A value of null indicates no limit.
  **
  native Int? limit

///////////////////////////////////////////////////////////
// execute
///////////////////////////////////////////////////////////

  **
  ** Execute the statement and return the resulting ResultSet
  **
  native Void query(|DataSet| f)

  **
  ** Execute a SQL statement and return number of rows modified.
  **
  native Int execute()

}