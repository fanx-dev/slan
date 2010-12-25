//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-12-25  Jed Young  Creation
//


**
** html tag
**
abstract class HTag
{
  Str? klass
  Str? id
  Str? style
  Str? title

  Str? accesskey
  Str? tabindx

  virtual Void parse(InStream in) {}
  virtual Void write(OutStream out) {}
}

abstract class EventTag : HTag
{
  Str? onblur
  Str? onclick
  Str? ondblclick
  Str? onfocus
  Str? onkeypress
  Str? onkeydown
  Str? onkeyup
  Str? onmousedown
  Str? onmouseup
  Str? onmousemove
  Str? onmouseout
}

abstract class BlockTag : EventTag
{
  HTag[] children

  Void add(HTag tag)
  {
    children.add(tag)
  }
}

class Text : InlineTag
{
  Str text
  new make(Str text)
  {
    this.text = text
  }
}

abstract class InlineTag : EventTag
{
  HTag[] children

  Void add(InlineTag tag)
  {
    children.add(tag)
  }
}

