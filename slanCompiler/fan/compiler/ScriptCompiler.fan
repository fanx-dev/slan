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
  private const ScriptCache cache := ScriptCache()

  new make(Str? podName := null)
  {
    this.podName = podName
  }

  ** from cache or compile
  Type getType(File file)
  {
    cache.getOrAdd(file){ compile(file) }
  }

  //compile
  protected Type compile(File file)
  {
    source := codeTranslate(file)
    Pod? pod
    try
    {
      pod = compileScript(source, file)
    }
    catch (CompilerErr e)
    {
      throw SlanCompilerErr(e, source, file.toStr)
    }
    type := pod.types[0]
    return type
  }

  Void clearCache()
  {
    cache.clear
  }

  protected virtual Str codeTranslate(File file)
  {
    source := file.readAllStr
    if (podName == null) return source
    return "using $podName
            $source"
  }

  //compileFantomScript
  private Pod compileScript(Str source, File file)
  {
    input := CompilerInput
    {
      it.podName  = "file_$file.basename$DateTime.nowUnique"
      summary     = "slanScript"
      isScript    = true
      version     = Version.defVal
      it.log.level   = LogLevel.warn
      output      = CompilerOutputMode.transientPod
      mode        = CompilerInputMode.str
      srcStr      = source
      srcStrLoc   = Loc.makeFile(file, 100, 100)
      it.depends = [Depend("sys 2.0"), Depend("std 1.0")]
    }

    return Compiler(input).compile.transientPod
  }
}