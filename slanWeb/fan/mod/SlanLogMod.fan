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
//using wisp
using compiler
using concurrent

**
** default LogMod
**
const class SlanLogMod : LogMod
{
  new make(Uri logDir := `log/`) : super(|LogMod log|
  {
    // create log dir is it doesn't exist
    logFile := logDir.toFile
    if (!logFile.exists) logFile.create

    dir = logFile
    filename = "web.log"

    // log systome info to console
    sysLogger := FileLogger { it.dir = logFile; it.filename = "sys.log" }
    Log.addHandler |rec| { sysLogger.writeLogRec(rec) }
  }){}
}