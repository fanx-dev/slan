//
// Copyright (c) 2007, Brian Frank and Andy Frank
// Licensed under the Academic Free License version 3.0
//
// History:
//   2011-11-5  Jed Young  Creation
//

mixin Row
{
  abstract Col[] cols()
  abstract Col? col(Str name, Bool checked := true)
  @Operator abstract Obj? get(Int i)
}

**
** ResultSet is a query result Cursor.
** See [pod-doc]`pod-doc#row`.
**
class DataSet : Row
{

  **
  ** Get a read-only list of the columns.
  **
  override native Col[] cols()

  **
  ** Get a column by name.  If not found and checked
  ** is true then throw ArgErr, otherwise return null.
  **
  override native Col? col(Str name, Bool checked := true)

  **
  ** Get column value.
  ** See [type mapping]`pod-doc#typeMapping`.
  **
  @Operator override native Obj? get(Int i)

  **
  ** Move the cursor to the next row.
  **
  native Bool next()

  **
  ** Move the cursor to an absolute position..
  **
  native Bool moveTo(Int pos)

}