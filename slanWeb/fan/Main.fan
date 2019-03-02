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

internal class Main : AbstractMain
{
  @Opt { help = "pod name to run" }
  Str? podName

  @Opt { help = "app src home path" }
  Uri? resPath

  @Opt { help = "http port" }
  Int port := 8080

  override Int run()
  {
    // run WispService
    return runServices(
      [ 
        WispService {
          it.httpPort = this.port
          root = RootMode(podName, resPath)
        }
      ]
    )
  }
}

