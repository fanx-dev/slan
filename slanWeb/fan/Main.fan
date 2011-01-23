//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

using util
using wisp
using web
using concurrent

**
** comment line tool to run web app
**
class Main : CommandLine
{

  @Arg { help = "your app path" }
  Uri? appHome

  @Opt { help = "http port"; aliases = ["p"]}
  Int port := 8081

  override Int run()
  {
    //init service
    wisp := WispService
    {
      it.port = this.port
      it.root = RootModWrapper(appHome)
    }

    //run service
    asyRunService([wisp])

    //read command line input
    processInput()

    return -1
  }
}