//
// Copyright (c) 2017-2017, chunquedong
//
//
// History:
//   2017-01-17  Jed Young  Creation
//

using util
using concurrent

**
** run process
** auto restart on crash or file changed
** usage: fan ./Restarter.fan -watch bin/,res/ -time 1sec  ./service.exe args
**
class Restarter : AbstractMain {
  @Opt { help = "watch list" }
  Str? watch

  @Opt { help = "checkTime" }
  Duration time := 5sec

  @Arg { help = "commands" }
  Str[]? commands

  private static const Unsafe process := Unsafe(RProcess())

  override Int run() {
    if (watch != null) {
      watcher := FileWatchActor {
        fileList = watch.split(',').map { it.toUri.toFile }
        echo("watchList: $fileList")
        onChanged = |->| { process.val->close }
        checkTime = time
      }
    }
    Env.cur.addShutdownHook |->| { process.val->close }
    process.val->commands = commands
    process.val->run
    return 0
  }
}

internal class RProcess {
  ** current process
  private Process? process
  Str[]? commands

  ** kill process
  Void close() {
    if (process != null) {
      try {
        echo("kill process")
        process.kill
        process = null
      }
      catch (Err e2) {}
    }
  }

  Int run() {
    while (true) {
      echo("run $commands")
      try {
        process = Process(commands).run
        process.join
      }
      catch (Err e) e.trace

      Actor.sleep(1sec)
    }

    close
    return 0
  }
}

**
** notify if file changed
**
const class FileWatchActor : Actor {
  static const Str storeKey := "watchActor.map"
  const File[]? fileList
  const |->|? onChanged
  const Duration checkTime := 5sec

  new make(|This| f) : super(ActorPool{maxThreads=1}) {
    f(this)
    sendLater(1sec, null)
  }

  protected override Obj? receive(Obj? msg) {
    try {
      sendLater(checkTime, null)

      if (fileList == null) return null

      [Str:DateTime] map := locals.getOrAdd(storeKey) { Str:DateTime[:] }
      Bool changed := false

      fileList.each |dir| {
        if (changed) return

        dir.walk |file| {
          key := file.toStr
          time := map[key]
          if (time != null) {
            if (file.modified > time) {
              changed = true
              return
            }
          }
          map[key] = file.modified
        }
      }

      if (changed) {
        echo("file changed")
        locals.remove(storeKey)
        onChanged?.call()
      }
    }
    catch (Err e) { e.trace }
    return null
  }
}