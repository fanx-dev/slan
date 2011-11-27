#! /usr/bin/env fan
//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2011-11-27  Jed Young  Creation
//

using build

class Build : build::BuildPod
{
  new make()
  {
    podName = "slanActor"
    summary = "saln actor util"
    srcDirs = [`fan/`, `fan/cache/`]
    depends = ["sys 1.0", "concurrent 1.0"]
  }
}