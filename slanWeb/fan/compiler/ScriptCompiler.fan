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
  protected const SlanApp slanApp
  private const ScriptCache cache := ScriptCache()

  new make(SlanApp slanApp)
  {
    this.slanApp = slanApp
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
    podName := slanApp.podName
    return "using $podName
            $source"
  }

  //compileFantomScript
  private Pod compileScript(Str source, File file)
  {
    input := CompilerInput
    {
      it.podName  = "$file.basename$DateTime.nowUnique"
      summary     = "slanScript"
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