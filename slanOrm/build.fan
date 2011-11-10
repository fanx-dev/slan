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
    podName = "slanDao"
    summary = "slan ORM"
    srcDirs = [`test/`, `test/sql/`, `test/cache/`, `test/base/`,
      `fan/`, `fan/sql/`, `fan/model/`, `fan/dialect/`, `fan/cache/`, `fan/dataSource/`]
    depends = ["sys 1.0","sql 1.0","concurrent 1.0"]
  }
}