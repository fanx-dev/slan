//
// Copyright (c) 2007, Brian Frank and Andy Frank
// Licensed under the Academic Free License version 3.0
//
// History:
//   2011-11-5  Jed Young  Creation
//

**
** ResultSet is a query result Cursor.
** See [pod-doc]`pod-doc#row`.
**
class ResultSet
{

  **
  ** Get a read-only list of the columns.
  **
  native Col[] cols()

  **
  ** Get a column by name.  If not found and checked
  ** is true then throw ArgErr, otherwise return null.
  **
  native Col? col(Str name, Bool checked := true)

  **
  ** Get column value.
  ** See [type mapping]`pod-doc#typeMapping`.
  **
  native Obj? get(Int i)

  **
  ** Move the cursor to the next row.
  **
  native Bool next()

  **
  ** Move the cursor to an absolute position..
  **
  native Bool moveTo(Int pos)

  **
  ** Release resource
  **
  native Void close()

}