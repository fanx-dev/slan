//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

internal class HtmlTemComTest : Test
{
  Void test()
  {
    Pod.of(this).log.level = LogLevel.debug
    TemplateCompiler c := TemplateCompiler.templateCompiler
    c->getType(`fan://slanWeb/res/welcome.html`.get)
    Pod.of(this).log.level = LogLevel.info
  }
}