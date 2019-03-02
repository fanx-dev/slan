#! /usr/bin/env fan
//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

using build

**
** Build: slanweb
**
class Build : BuildPod
{
  new make()
  {
    podName = "slanCompiler"
    summary = "slan template compiler"
    depends =
    [
        "sys 2.0", "std 1.0",
        "web 1.0",
        "compiler 1.1",
        "concurrent 1.0",
    ]
    srcDirs = [`test/`, `fan/`, `fan/compiler/`, `fan/template/`]
    resDirs = [`res/`]
  }
}