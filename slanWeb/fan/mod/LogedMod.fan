//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

using util
using web
using webmod
using wisp
using compiler
using concurrent

**
** add log for mod
**
const class LogedMod : SlanRouteMod
{
  private const Uri logDir
  private const LogMod logger

  new make(Uri logDir := `log/`) : super()
  {
    this.logDir = logDir
    logger = initLoger
  }

  override Void onService()
  {
    try
      super.onService
    finally
      logger.onService
  }

  ** create logMod
  private LogMod initLoger()
  {
    // create log dir is it doesn't exist
    logFile := logDir.toFile
    if (!logFile.exists) logFile.create

    // install sys log handler
    sysLogger := FileLogger { dir = logFile; filename = "sys.log" }
    Log.addHandler |rec| { sysLogger.writeLogRec(rec) }

    return LogMod { dir = logFile; filename = "web.log" }
  }
}