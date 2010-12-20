//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-12-20  Jed Young  Creation
//

internal class UtilTest : Test
{

  Void testAllDir()
  {
    subs := Util.allDir(`file:/D:/code/Hg/slan2/slanWeb/`, `fan/`)
    echo(subs)
  }
}