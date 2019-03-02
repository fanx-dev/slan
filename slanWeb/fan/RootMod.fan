

using webmod
using web
using util

const class RootMode : WebMod {

  const PipelineMod pipeline
  const PodResMod podMod := PodResMod()

  new make() : this.makeFrom(null, `./public`) {
  }

	new makeFrom(Str? podName, Uri? resPath, |This|? f := null) {
    // create log dir if it doesn't exist    
    logDir := (resPath == null || resPath.parent == null) ? `./logs/`.toFile : (`${resPath.parent}/logs/`).toFile

    echo("init podName:$podName resPath:$resPath log:$logDir")
    if (!logDir.exists) logDir.create

    // install sys log handler
    sysLogger := FileLogger { dir = logDir; filename = "sys-{YYYY-MM-DD}.log" }
    Log.addHandler |rec| { sysLogger.writeLogRec(rec) }

    // pipeline steps
    pipeline = PipelineMod {
      steps =
      [
        ScriptMod(resPath?.toFile, podName),
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
      //echo("pod file :$req.modRel")
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

