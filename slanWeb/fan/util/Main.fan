//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-12-20  Jed Young  Creation
//

using util
using inet
using wisp
using concurrent

internal class Main : AbstractMain
{
  @Arg { help = "pod name to run" }
  Str? podName

  @Opt { help = "app src home path" }
  Str? appHome

  @Opt { help = "IP address to bind to" }
  Str? addr

  @Opt { help = "http port" }
  Int port := 8080

  override Int run()
  {
    Actor.locals["slan.appHome"] = appHome
    SlanApp.init(podName)

    rc := runServices([WispService
    {
      it.addr = this.addr == null ? null : IpAddr(this.addr)
      it.port = this.port
      it.root = SlanRouteMod()
    }])

    return rc
  }
}