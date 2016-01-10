//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-12-22  Jed Young  Creation
//

using slanWeb

const class Controller : SlanWeblet
{
  override Obj? trap(Str name, Obj?[]? args := null)
  {
    echo("before")
    try
      return SlanWeblet.super.trap(name, args)
    finally
      echo("finally")
  }

}