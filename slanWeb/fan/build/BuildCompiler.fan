//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-12-4  Jed Young  Creation
//

using build

**
** compiler build script and run it
**
internal const class BuildCompiler : ScriptCompiler
{
  new make(SlanApp slanApp) : super(slanApp) {}

  ** run build and return podName
  Str runBuild(File file)
  {
    Type type := compile(file)
    BuildPod build := type.make
    Str name := build.podName + "_" + DateTime.nowUnique
    build.podName = name
    build.compile
    return name
  }

  protected override Str codeTranslate(File file)
  {
    script := file.readAllStr
    return script.replace("build::BuildPod", TransientBuild#.qname)
                 .replace("BuildPod", TransientBuild#.qname)
  }
}

