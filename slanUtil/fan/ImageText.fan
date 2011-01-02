//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2011-01-01  Jed Young  Creation
//

using [java]java.awt
using [java]java.io
using [java]java.util
using [java]javax.imageio
using [java]java.awt.image
using [java]java.awt.geom
using [java]fanx.interop

**
** draw text to image
**
class ImageText
{
  const Int width := 120
  const Int height := 25
  const Int fontSize := 24
  BufferedImage img
  Graphics2D? g

  new make(|This|? f := null)
  {
    f?.call(this)
    img = BufferedImage(width, height, BufferedImage.TYPE_INT_RGB)
    g = img.getGraphics() as Graphics2D
    g.setBackground(Color.white);
    g.clearRect(0, 0, width, height);
    g.setColor(Color.black)
  }

  Void dump(OutStream out)
  {
    ImageIO.write(img, "JPG", Interop.toJava(out));
  }

  Void drawStr(Str char, Int x := 0, Int y := 20)
  {
    g.setFont(Font("Arial", Font.BOLD.or(Font.ITALIC), fontSize))
    g.drawString(char, x, y)
  }

  Void setColor(Int r, Int g_, Int b)
  {
    g.setColor(Color(r, g_, b))
  }

  Void drawPointNoise()
  {
    x1 := Int.random(0..width)
    y1 := Int.random(0..height)
    w := Int.random(1..3)
    h := Int.random(1..3)

    g.fillOval(x1, y1, w, h)
  }
}