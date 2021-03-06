#! /usr/bin/env fan
//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

using build

class Build : build::BuildPod
{
  new make()
  {
    podName = "slanUtil"
    summary = "slan util"
    srcDirs = [`fan/`, `test/`]
    depends = ["sys 2.0", "std 1.0", "concurrent 1.0", "web 1.0", "util 1.0"]
  }
}