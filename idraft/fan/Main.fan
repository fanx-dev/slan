//
// Copyright (c) 2011, Andy Frank
// Licensed under the MIT License
//
// History:
//   7 Jun 2011  Andy Frank  Creation
//   2011-11-20  Jed Young
//

using concurrent
using util
using web
using wisp
using inet


**
** Main entry-point for Draft CLI tools.
**
class Main : AbstractMain
{
  @Arg { help = "qualified type name for WebMod to run" }
  Str? mod

  @Opt { help = "other args" }
  Str? args

  @Opt { help = "IP address to bind to" }
  Str? addr

  @Opt { help = "http port" }
  Int port := 8080

  override Int run()
  {
    type := Type.find(this.mod)

    // start restarter actor
    restarter := DevRestarter(ActorPool(), type, port+1, args)

    // start proxy server
    devmod := DevMod(restarter)

    return runServices([WispService
    {
      it.addr = this.addr == null ? null : IpAddr(this.addr)
      it.port = this.port
      it.root = devmod
    }])
  }
}