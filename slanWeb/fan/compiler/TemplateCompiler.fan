//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

using web
using compiler

**
** compile and run template file
**
const class TemplateCompiler : ScriptCompiler
{
  private const TemplateConverter codeTrans := TemplateConverter()

  static const TemplateCompiler instance := TemplateCompiler()

  private new make(){}

  Void render(File file, |->|? lay := null)
  {
    type := getType(file)
    obj := type.make
    type.method("dump").call(obj, lay)
  }

  protected override Str codeTransform(File file)
  {
    return codeTrans.transform(file)
  }
}