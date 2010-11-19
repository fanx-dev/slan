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
const class TemplateCompiler
{

  private const ScriptCache cache := ScriptCache()
  private const CodeTransform codeTrans := CodeTransform()

  static const TemplateCompiler instance := TemplateCompiler()

  private new make(){}

  Void render(File file, |->|? lay := null)
  {
    type := getType(file)
    obj := type.make
    type.method("dump").call(obj, lay)
  }

  ** from cache or compile
  private Type getType(File file)
  {
    cache.getOrAdd(file){ compile(file) }
  }

//////////////////////////////////////////////////////////////////////////
// compile
//////////////////////////////////////////////////////////////////////////

  //compile
  private Type compile(File file)
  {
    source := codeTrans.transform(file)
    Pod? pod
    try
    {
      pod = compileScript(source, file)
    }
    catch (CompilerErr e)
    {
      throw TemplateErr(e, source, file)
    }
    type := pod.type("HtmlTemplet")
    return type
  }

  //compileFantomScript
  private Pod compileScript(Str source, File file)
  {
    input := CompilerInput
    {
      it.podName  = "${file.basename}_$DateTime.nowUnique"
      summary     = "HtmlTemplet"
      isScript    = true
      version     = Version.defVal
      it.log.level   = LogLevel.warn
      output      = CompilerOutputMode.transientPod
      mode        = CompilerInputMode.str
      srcStr      = source
      srcStrLoc   = Loc.makeFile(file, 100, 100)
    }

    return Compiler(input).compile.transientPod
  }
}