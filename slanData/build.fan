#! /usr/bin/env fan
//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-12-24  Jed Young  Creation
//

using build
class Build : build::BuildPod
{
  new make()
  {
    podName = "slanData"
    summary = "sql resultSet to XML/JSON"
    srcDirs = [`fan/`, `test/`]
    depends = ["sys 1.0","isql 1.0","concurrent 1.0"]
  }
}