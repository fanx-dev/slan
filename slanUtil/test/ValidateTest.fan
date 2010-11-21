//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-11-20  Jed Young  Creation
//

internal class ValidateTest : Test
{
  Void testIsEmail()
  {
    email0 := "chunquedong@gmail.com"
    verify(Validate.isEmail(email0))

    email2 := "chunque%dong@gmail"
    verifyFalse(Validate.isEmail(email2))

    email3 := "chunquedong@@gmail"
    verifyFalse(Validate.isEmail(email3))

    email4 := "chunquedong at gmail"
    verifyFalse(Validate.isEmail(email4))
  }
}