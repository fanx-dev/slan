//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-11-20  Jed Young  Creation
//

internal class PatchcaTest : Test
{
  Void testRandomCode()
  {
    patchca := Patchca(null)
    code := patchca.randomCode
    echo(code)
  }

  Void testOutputImage()
  {
    file := File.createTemp
    patchca := Patchca{ width = 200 }
    patchca.outputImage(file.out, "5xMio")
    echo(file)
  }

  Void test()
  {
    file := File.createTemp
    patchca := Patchca{}
    code := patchca.create(file.out)
    echo(code)
    echo(file)
  }
}