//
// Copyright (c) 2010, Yang Jiandong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Yang Jiandong  Creation
//

**
** MyWebUtil
**
class SlanUtil
{
  static Obj[] getParams(Str[] path,Param[] params,Int start){
    Obj[] list:=[,]
    for (i:=0; i<params.size; ++i)
    {
      list.add(typeConvert(path[i+start],params[i].type))
    }
    return list
  }

  private static Obj? typeConvert(Str? s,Type type){
    if(s==null)return null

    if(type.qname==Str#.qname){
      return s
    }else{
      return type.method("fromStr").call(s)
    }
  }

  static Obj?[] getParamsByName(Str:Str query,Param[] params,[Str:Str]? other){
    Obj?[] list:=[,]
    for (i:=0; i<params.size; ++i)
    {
      p:=params[i]
      s:=query[p.name]
      if(s==null && other!=null){
        s=other[p.name]
      }
      list.add(typeConvert(s,p.type))
    }
    return list
  }
}