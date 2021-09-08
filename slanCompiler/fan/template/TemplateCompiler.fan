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

  new make(Str? podName := null) : super(podName)
  {
    codeTrans = TemplateTranslater(podName)
  }

  Void render(File file, |->|? lay := null)
  {
    //echo("render $file")
    type := getType(file)
    obj := type.make()
    type.method("dump").callOn(obj, [lay])
  }

  protected override [Str:Obj] options(File file) {
    [Str:Obj] op := ["translate":|Str code->Str|{ codeTranslate(code, file) }]
    if (file.ext == "fsp") op["compiler"] = "fan"
    return op
  }

  protected override Str codeTranslate(Str code, File file)
  {
    if (file.ext == "fsp") {
      return codeTrans.translate(code)
    }
    else {
      return codeTrans.translateFanx(code)
    }
  }
}