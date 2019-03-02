

using webmod
using web
using util

const class RootMode : WebMod {

  const PipelineMod pipeline
  const PodResMod podMod := PodResMod()

  new make() : this.makeFrom(null, `./res`.toFile) {
  }

	new makeFrom(Str? podName, File? resPath, |This|? f := null) {
    // create log dir if it doesn't exist
    echo("init podName:$podName resPath:$resPath")
    logDir := resPath.parent == null ? `./logs/`.toFile : (resPath.parent + `/logs/`)
    echo("log to $logDir")
    if (!logDir.exists) logDir.create

    // install sys log handler
    sysLogger := FileLogger { dir = logDir; filename = "sys-{YYYY-MM-DD}.log" }
    Log.addHandler |rec| { sysLogger.writeLogRec(rec) }

    // pipeline steps
    pipeline = PipelineMod {
      steps =
      [
        ScriptMod(resPath, podName),
        SFileMod { file = resPath },
      ]

      // steps to run after every request
      after =
      [
        LogMod { dir = logDir; filename = "web-{YYYY-MM-DD}.log" }
      ]
    }

    f?.call(this)
	}

  override Void onStart()
  {
    pipeline.onStart
  }

  override Void onStop()
  {
    pipeline.onStop
  }

  override Void onService()
  {
    name := req.modRel.path.first

    if (name == "pod") {
      req.mod  = podMod
      podMod.onService
      return
    }

    req.mod = pipeline
    pipeline.onService
  }
}

**
** only for pod's javascript file
**
const class PodResMod : WebMod
{
  override Void onService()
  {
    //this is only valid for javascript file
    if(req.modRel.ext == "apidoc" || req.modRel.ext == "def")
    {
      res.sendErr(403)
      return
    }
    req.modBase = `/pod/`
    uri := ("fan://" + req.modRel).toUri
    try {
      echo("pod file :$req.modRel")
      file := uri.get
      FileWeblet(file).onService
    }
    catch (Err e)
    {
      e.trace
      res.sendErr(404)
      return
    }
  }
}

