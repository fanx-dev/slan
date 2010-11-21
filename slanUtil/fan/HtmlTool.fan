//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-11-20  Jed Young  Creation
//

const class HtmlTool
{
  static Str encodeToHtml(Str text)
  {
    text
     .replace("<","&lt;")
     .replace(">","&gt;")
     .replace("&","&amp;")
     .replace(" ","&nbsp;")
  }
}