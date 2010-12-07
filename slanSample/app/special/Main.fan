//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

using slanWeb::SlanRouteMod
using slanWeb::Config
using slanWeb::LogedMod
using wisp
using concurrent

**
** Main
**
class Main
{
  **
  ** run wisp service
  **
  static Void main()
  {
    wisp := WispService
    {
      it.port = Main#.pod.config("port", "8080").toInt
      it.root = ProductMod()
    }
    wisp.install
    wisp.start
    Actor.sleep(Duration.maxVal)
  }
  **
  ** for jsDist to init classPath
  **
  static Void init() {}
}

**
** this be used for fanlet as root web mod
**
const class ProductMod : LogedMod
{
  const static Pod pod := Main#.pod
  new make() : super(SlanRouteMod(), pod.config("log", "/log/").toUri)
  {
    Config.cur.toProductMode(pod.name)
  }
}