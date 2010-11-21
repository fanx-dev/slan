//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-11-20  Jed Young  Creation
//

using [java]java.awt
using [java]java.io
using [java]java.util
using [java]javax.imageio
using [java]java.awt.image
using [java]java.awt.geom
using [java]fanx.interop

**
** generate the image auth code
**
const class Patchca
{
  ** image size
  const Int width := 120
  const Int height := 25

  ** char num
  const Int n := 5

  const Int margin := 5
  const Int charPad := 15
  const Int noise := 3

  new make(|This|? f := null)
  {
    f?.call(this)
  }

  **
  ** output the image to stream, and return the generate code
  **
  Str create(OutStream out)
  {
    code := randomCode
    outputImage(out, code)
    return code
  }

  internal Void outputImage(OutStream out, Str code)
  {
    img := BufferedImage(width, height, BufferedImage.TYPE_INT_RGB)
    g := img.getGraphics() as Graphics2D

    g.setBackground(Color.white);
    g.clearRect(0, 0, width, height);

    setRandomColor(g)
    code.each |Int char, Int i|
    {
      rotate(g, center(i), middle)
      drawCode(char.toChar, g, i)
      drawPointNoise(g)
    }
    resetTransform(g)
    drawNoise(g)

    ImageIO.write(img, "JPG", Interop.toJava(out));
  }

  private Void drawCode(Str char, Graphics2D g, Int i)
  {
    g.setFont(Font("Arial", Font.BOLD.or(Font.ITALIC), 22))
    g.drawString(char, left(i), base)
  }

  ** get random code
  internal Str randomCode()
  {
    Int[] list := "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789".chars
    Int[] code := [,]
    n.times
    {
      code.add(list.random)
    }
    return Str.fromChars(code)
  }

//////////////////////////////////////////////////////////////////////////
// util
//////////////////////////////////////////////////////////////////////////

  private Void setRandomColor(Graphics2D g)
  {
    r := Int.random(0..200)
    g_ := Int.random(0..200)
    b := Int.random(0..200)
    g.setColor(Color(r, g_, b))
  }

  private Void rotate(Graphics2D g, Float anchorx, Float anchory)
  {
    theta := Float.random - 0.6f
    transform := AffineTransform()
    {
      it.rotate(theta, anchorx, anchory)
    }

    g.setTransform(transform)
  }

  private Void resetTransform(Graphics2D g)
  {
    transform := AffineTransform()
    g.setTransform(transform)
  }

//////////////////////////////////////////////////////////////////////////
// letter position
//////////////////////////////////////////////////////////////////////////

  ** one char size
  private Float charWidth()
  {
    contentWidth := width.toFloat - (margin + margin)
    fontWidth := contentWidth - (n * charPad)
    return ( fontWidth / n )
  }

  private Float top() { margin.toFloat }

  private Float base()
  {
    height.toFloat - margin
  }

  private Float left(Int i)
  {
    margin.toFloat + ( (charWidth + charPad) * i)
  }

  private Float middle() { height / 2f }

  private Float center(Int i)
  {
    left(i) + charWidth / 2f
  }

//////////////////////////////////////////////////////////////////////////
// noise
//////////////////////////////////////////////////////////////////////////

  private Void drawNoise(Graphics2D g)
  {
    drawLongLine(g)
  }

  private Void drawPointNoise(Graphics2D g)
  {
    noise.times{ drawPoint(g) }
  }

  private Void drawLongLine(Graphics2D g)
  {
    x1 := Int.random(margin..margin + 10)
    y1 := Int.random(margin..height - margin)
    x2 := Int.random((width - (margin + 10))..(width - margin))
    y2 := Int.random(margin..height - margin)

    //setRandomColor(g)
    g.setStroke(BasicStroke(2f))
    g.drawLine(x1, y1, x2, y2)
  }

  private Void drawPoint(Graphics2D g)
  {

    x1 := Int.random(0..width)
    y1 := Int.random(0..height)
    w := Int.random(1..5)
    h := Int.random(1..5)

    g.fillOval(x1, y1, w, h)
  }
}