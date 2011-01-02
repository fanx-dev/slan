//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-11-20  Jed Young  Creation
//

internal class ImageTextTest : Test
{
  Void testDraw()
  {
    file := File(`/D:/Temp/test/imgText.jpg`)
    img := ImageText{ width = 300; height = 300 }
    img.drawStr("5xMio")
    2000.times{ img.drawPointNoise }
    img.dump(file.out)
  }
}