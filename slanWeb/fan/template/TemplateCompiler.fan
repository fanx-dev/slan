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
** compile and run http template file
**
const class TemplateCompiler : ScriptCompiler
{
  private const TemplateTranslater codeTrans

  new make(SlanApp slanApp) : super(slanApp)
  {
    codeTrans = TemplateTranslater(slanApp)
  }

  Void render(File file, |->|? lay := null, WebOutStream? out := null)
  {
    type := getType(file)
    obj := type.make()
    type.method("dump").callOn(obj, [lay, out])
  }

  protected override Str codeTranslate(File file)
  {
    return codeTrans.translate(file)
  }
}