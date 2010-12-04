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
class Main : AbstractMain
{

  @Arg { help = "your app path" }
  Uri? appHome

  @Opt { help = "http port"; aliases = ["p"]}
  Int port := 8080

  override Int run()
  {
    i := Process(["fan", "slanWeb::CommandLine", appHome.toStr, "-p", "$port"]).run().join()
    if (i == 2025)
    {
      return run
    }
    return i
  }
}