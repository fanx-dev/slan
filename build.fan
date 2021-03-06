#! /usr/bin/env fan
//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-11-20  Jed Young  Creation
//

using build

**
** Build flux/ pods
**
class Build : BuildGroup
{

  new make()
  {
    childrenScripts =
    [
      `isql/build.fan`,
      `slanUtil/build.fan`,
      `slanCompiler/build.fan`,
      `slanWeb/build.fan`,
      `slanRecord/build.fan`
    ]
  }

}