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
    podName = "slanData"
    summary = "slan data model"
    srcDirs = [`fan/`]
    depends = ["sys 1.0"]
  }
}