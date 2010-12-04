//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

using util
using wisp

**
** Main
**
class CommandLine : AbstractMain
{

  @Arg { help = "your app path" }
  Uri? appHome

  @Opt { help = "http port"; aliases = ["p"]}
  Int port := 8080

  override Int run()
  {
    Config.cur.toDebugMode(appHome)
    wisp := WispService
    {
      it.port = this.port
      it.root = SlanRouteMod()
    }
    return runServices([wisp])
  }
}