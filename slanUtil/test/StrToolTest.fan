//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-11-20  Jed Young  Creation
//

class StrToolTest : Test
{
  Void testEncrypt()
  {
    secret :=  StrTool.encrypt("hello world")
    echo(secret)

    secret2 :=  StrTool.encrypt("hello world")
    verifyEq(secret, secret2)
  }
}