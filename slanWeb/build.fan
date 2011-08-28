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
        "sys 1.0",
        "webmod 1.0",
        "web 1.0",
        "compiler 1.0",
        "wisp 1.0",
        "util 1.0",
        "concurrent 1.0",
        "build 1.0",
        "draft 1.0"
    ]
    srcDirs = [`test/`, `fan/`, `fan/mod/`, `fan/compiler/`, `fan/action/`, `fan/template/`, `fan/util/`]
    resDirs = [`res/`]
  }
}