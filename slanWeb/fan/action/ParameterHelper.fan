//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

**
** helper for parse parameter
**
class ParameterHelper
{
  ** get constructorParams
  static Obj?[] getParams(Str[] path, Param[] params, Int start)
  {
    Obj?[] list := [,]
    for (i := 0; i < params.size; ++i)
    {
      p := params[i]
      if (i + start < path.size)
      {
        value := typeConvert(path[i+start], p.type)
        list.add(value)
        continue
      }

      if (p.hasDefault)
      {
        break
      }
      else if (p.type.isNullable)
      {
        list.add(null)
        break
      }
      else
      {
        throw ArgErr("too less parameter")
      }
    }
    return list
  }

  ** convert string to object,by 'fromStr' method
  private static Obj typeConvert(Str s, Type type)
  {
    if (type.qname == Str#.qname)
    {
      return s
    }
    else
    {
      return type.method("fromStr").call(s)
    }
  }

  ** methodParams
  static Obj?[] getParamsByName(Str:Str query, Param[] params, [Str:Str]? other)
  {
    Obj?[] list := [,]
    for (i := 0; i < params.size; ++i)
    {
      Param p := params[i]
      value := query[p.name]
      if (value == null && other != null)
      {
        value = other[p.name]
      }

      if (value != null)
      {
        list.add(typeConvert(value, p.type))
        continue
      }

      if (p.hasDefault)
      {
        break
      }
      else if (p.type.isNullable)
      {
        list.add(null)
      }
      else
      {
        throw ArgErr("parameter $p.name is not found")
      }

    }
    return list
  }
}