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
** fantom code compiler
**
const class ScriptCompiler
{
  private const Str? podName

  new make(Str? podName := null)
  {
    this.podName = podName
  }

  ** from cache or compile
  Type getType(File file)
  {
    try {
      return Env.cur.compileScript(file, options(file))
    }
    catch (CompilerErr e) {
      throw SlanCompilerErr(e, codeTranslate(file.readAllStr, file), file.toStr)
    }
  }

  protected virtual [Str:Obj] options(File file) {
    ["translate":|Str code->Str|{ codeTranslate(code, file) }]
  }

  protected virtual Str codeTranslate(Str source, File file)
  {
    if (podName == null) return source
    return "using $podName
            $source"
  }
}