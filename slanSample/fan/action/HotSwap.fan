//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

using slanWeb

**
** code hot change
**
class HotSwap : SlanWeblet
{
  Void index()
  {
    setContentType
    res.out.w(HotSwapTest.s)
  }
}