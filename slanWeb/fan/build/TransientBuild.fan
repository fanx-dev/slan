//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-12-4  Jed Young  Creation
//

using build
using compiler

**
** build pod on CompilerOutputMode.transientPod
** this must be public
**
class TransientBuild : BuildPod
{
  **
  ** Compile Fan code into pod file
  **
  override Void compileFan()
  {
    // add my own meta
    meta := this.meta.dup
    meta["pod.docApi"] = docApi.toStr
    meta["pod.docSrc"] = docSrc.toStr
    meta["pod.native.java"]   = (javaDirs   != null && !javaDirs.isEmpty).toStr
    meta["pod.native.dotnet"] = (dotnetDirs != null && !dotnetDirs.isEmpty).toStr
    meta["pod.native.js"]     = (jsDirs     != null && !jsDirs.isEmpty).toStr

    // map my config to CompilerInput structure
    ci := CompilerInput()
    ci.inputLoc    = Loc.makeFile(scriptFile)
    ci.podName     = podName
    ci.summary     = summary
    ci.version     = version
    ci.depends     = depends.map |s->Depend| { Depend(s) }
    ci.meta        = meta
    ci.index       = index
    ci.baseDir     = scriptDir
    ci.srcFiles    = srcDirs
    ci.resFiles    = resDirs
    ci.jsFiles     = jsDirs
    ci.log         = log
    ci.includeDoc  = docApi
    ci.mode        = CompilerInputMode.file
    ci.outDir      = outDir.toFile
    ci.output      = CompilerOutputMode.transientPod

    if (dependsDir != null)
    {
      f := dependsDir.toFile
      if (!f.exists) throw fatal("Invalid dependsDir: $f")
      ci.ns = FPodNamespace(f)
    }

    try
    {
      Compiler(ci).compile
    }
    catch (CompilerErr err)
     {
      // all errors should already be logged by Compiler
      // throw FatalBuildErr("BUILD FAILED", err)
      // echo(err.file)
      source := File.os(err.file).readAllStr
      throw SlanCompilerErr(err, source, err.file)
    }
    catch (Err err)
    {
      log.err("Internal compiler error")
      err.trace
      throw FatalBuildErr.make
    }
  }
}

