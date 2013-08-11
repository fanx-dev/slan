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
    podName = "slanRecord"
    summary = "slan record"
    srcDirs = [`fan/`, `fan/model/`, `fan/dataSource/`, `fan/sql/`, `test/`]
    depends = ["sys 1.0", "isql 1.0", "concurrent 1.0", "slanActor 1.0"]
  }
}