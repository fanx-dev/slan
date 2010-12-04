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
  private const ScriptCache cache := ScriptCache()

  ** from cache or compile
  Type getType(File file)
  {
    cache.getOrAdd(file){ compile(file) }
  }

  //compile
  private Type compile(File file)
  {
    source := codeTransform(file)
    Pod? pod
    try
    {
      pod = compileScript(source, file)
    }
    catch (CompilerErr e)
    {
      throw SlanCompilerErr(e, source, file)
    }
    type := pod.types[0]
    return type
  }

  protected virtual Str codeTransform(File file)
  {
    source := file.readAllStr
    podName := Config.cur.getPodName
    return "using $podName
            $source"
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