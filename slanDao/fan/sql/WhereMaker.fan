//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

**
** make condition ,the object as a template
** 
internal const class WhereMaker
{
  Str getSql(Table table, Obj obj)
  {
    from := "from $table.name"
    condition := StrBuf()
    table.columns.each
    {
      if (it.field.get(obj) != null)
      {
        condition.add("$it.name=@$it.name and ")
      }
    }
    
    if (condition.size == 0){
      return from
    }
    
    condition.removeRange(Range.makeInclusive(condition.size-5,-1))
    return "$from where $condition"
  }
  
  Str:Obj getParam(Table table, Obj obj)
  {
    Str:Obj param := [:]
    table.columns.each |Column c|
    {
      value := c.getValue(obj)
      if (value != null)
      {
        param[c.name] = value
      }
    }
    return param
  }
}
