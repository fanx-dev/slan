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
    podName = "slanWeb"
    summary = "slan web framework"
    depends =
    [
        "sys 2.0", "std 1.0",
        "webmod 1.0",
        "web 1.0",
        "util 1.0",
        "concurrent 1.0",
        "slanCompiler 1.0",
        "inet 1.0",
        "wisp 1.0"
    ]
    srcDirs = [`test/`, `fan/`, `fan/action/`]
    //resDirs = [`res/`]
  }
}