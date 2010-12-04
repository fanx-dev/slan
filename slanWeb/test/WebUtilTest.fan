//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

**
** MyWebUtilTest
**
internal class WebUtilTest : Test
{
  Void m4test(Int i,Str s) {}

  Void testGetParams()
  {
    objs := ParameterHelper.getParams(["action", "welcom", "123", "p2"],
      #m4test.params, 2)
    this.verify(objs.size == 2)
    this.verify(objs[0] == 123)
    this.verify(objs[1] == "p2")

    #m4test.callOn(this, objs)
  }

  Void testGetParamsByName()
  {
    objs := ParameterHelper.getParamsByName(["s":"p2"], #m4test.params, ["i":"123"])
    this.verify(objs.size == 2)
    this.verify(objs[0] == 123)
    this.verify(objs[1] == "p2")

    #m4test.callOn(this, objs)
  }
}