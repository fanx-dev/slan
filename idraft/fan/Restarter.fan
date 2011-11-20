//
// Copyright (c) 2011, Andy Frank
// Licensed under the MIT License
//
// History:
//   6 Jun 2011  Andy Frank  Creation
//

using concurrent


//////////////////////////////////////////////////////////////////////////
// DevRestarter
//////////////////////////////////////////////////////////////////////////

** DevRestarter
const class DevRestarter : Actor
{
  new make(ActorPool p, Type type, Int port, Str? args) : super(p)
  {
    this.type = type
    this.port = port
    this.args = args
  }

  ** Check if pods have been modified.
  Void checkPods() { send("verify").get(30sec) }

  override Obj? receive(Obj? msg)
  {
    if (msg == "verify")
    {
      map := Actor.locals["ts"] as Pod:DateTime
      if (map == null)
      {
        startProc
        Actor.locals["ts"] = update
      }
      else if (podsModified(map))
      {
        log.info("Pods modified, restarting WispService")
        stopProc; startProc; Actor.sleep(2sec)
        Actor.locals["ts"] = update
      }
    }
    return null
  }

  ** Update pod modified timestamps.
  private Pod:DateTime update()
  {
    map := Pod:DateTime[:]
    Pod.list.each |p| { map[p] = podFile(p).modified }
    log.debug("Update pod timestamps ($map.size pods)")
    return map
  }

  ** Return pod file for this Pod.
  private File podFile(Pod pod)
  {
    Env? env := Env.cur
    file := env.workDir + `_doesnotexist_`

    // walk envs looking for pod file
    while (!file.exists && env != null)
    {
      file = env.workDir + `lib/fan/${pod.name}.pod`
      env = env.parent
    }

    // verify exists and return
    if (!file.exists) throw Err("Pod file not found $pod.name")
    return file
  }

  ** Return true if any pods have been modified since startup.
  private Bool podsModified(Pod:DateTime map)
  {
    true == Pod.list.eachWhile |p|
    {
      if (podFile(p).modified > map[p])
      {
        log.debug("$p.name pod has been modified")
        return true
      }
      return null
    }
  }

  ** Start DraftMod process.
  private Void startProc()
  {
    home := Env.cur.homeDir.osPath
    argsAll := ["java", "-cp", "${home}/lib/java/sys.jar", "-Dfan.home=$home",
             "fanx.tools.Fan", "wisp", "-port", "$port", type.qname]
    if (args != null) argsAll.add(args)

    proc := Process(argsAll).run

    Actor.locals["proc"] = proc
    log.debug("Start external process")
  }

  ** Stop DraftMod process.
  internal Void stopProc()
  {
    proc := Actor.locals["proc"] as Process
    if (proc == null) return
    proc.kill
    log.debug("Stop external process")
  }

  const Type type
  const Int port
  const Str? args
  const Log log := Log.get("idraft")
}

//////////////////////////////////////////////////////////////////////////
// DevMod
//////////////////////////////////////////////////////////////////////////

** DevMod
const class DevMod : Proxy
{
  ** Constructor.
  new make(DevRestarter r) : super(r.port)
  {
    this.restarter = r
  }

  ** DevRestarter instance.
  protected const DevRestarter restarter

  override Void beforeService() { restarter.checkPods }

  override Void onStop() { restarter.stopProc }
}