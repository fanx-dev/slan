//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-12-7  Jed Young  Creation
//

using slanWeb::LogedMod
using slanWeb::SlanApp

**
** root mod
**
const class RootMod : LogedMod
{

  const static Uri logDir := `log/`
  static
  {
    try
      logDir = Main#.pod.config("log").toUri
    catch(Err e){}
  }

  new make(SlanApp? slanApp := null) : super(
    slanApp ?: SlanApp.makeProduct(Main#.pod.name), logDir) {}

  **
  ** return false will cancle the request
  **
  override Bool beforeInvoke() { true }

  **
  ** guarantee will be called
  **
  override Void afterInvoke() {}


  override Void onStart() {}

  override Void onStop() {}
}