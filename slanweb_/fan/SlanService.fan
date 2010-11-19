//
// Copyright (c) 2010, Yang Jiandong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Yang Jiandong  Creation
//

using util
using web
using webmod
using wisp
using compiler
using concurrent

**
** web service
**
const class SlanService
{
  const SlanRouteMod? route
  const Uri logDir:=`log/`
  const Int port:=8080

  new make(|This| f){
    f(this)
    if(route==null){
      route=SlanRouteMod()
    }
  }

  Void run(){
    createService.start
    Actor.sleep(Duration.maxVal)
  }

  Service createService()
  {
    loger:=initLoger

    pipeline := PipelineMod
    {
        steps =[route]
        after=[loger]
    }

    return WispService {
      it.port = this.port
      root = pipeline 
    }
  }

  private LogMod initLoger(){
    // create log dir is it doesn't exist
    logFile := logDir.toFile
    if (!logFile.exists) logFile.create

    // install sys log handler
    sysLogger := FileLogger { dir = logFile; filename = "sys.log" }
    Log.addHandler |rec| { sysLogger.writeLogRec(rec) }

    return LogMod { dir = logFile; filename = "web.log" }
  }
}