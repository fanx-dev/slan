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
using draft

**
** comment line tool to run web app
**
class Main : AbstractMain
{

  @Arg { help = "your app path" }
  Uri? appHome

  @Opt { help = "http port"; aliases = ["p"]}
  Int port := 8081

  override Int run()
  {
    SlanApp slanApp := SlanApp.makeDebug(appHome)
    Actor.locals["slanWeb.slanApp"] = slanApp
    type := Pod.find(slanApp.podName).type("RootMod")

    // start restarter actor
    pool := ActorPool()
    restarter := DevRestarter(pool, type, port+1)
    WebMod mod := DevMod(restarter)

    // start proxy server
    return runServices([WispService { it.port=this.port; it.root=mod }])
  }
}