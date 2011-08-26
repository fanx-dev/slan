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
  override Int run()
  {
    runServices(
    [
      WispService
      {
        it.port = Main#.pod.config("port", "8081").toInt
        it.root = RootMod()
      }
    ])
  }

  **
  ** dummay method for jsDist to init classPath
  **
  static Void init() {}
}