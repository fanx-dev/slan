//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

using util
using wisp
using web
using concurrent

**
** comment line tool
**
abstract class CommandLine : AbstractMain
{
  ** run service
  virtual Void asyRunService(Service[] services)
  {
    Actor(ActorPool())|arg|
    {
      services.each{ it.install }
      services.each{ it.start }
      return null
    }.send(null)

    Env.cur.addShutdownHook( |->|{ uninstallService(services) }.toImmutable )
  }

  private static Void uninstallService(Service[] services)
  {
    services.each
    {
      try
        it.stop
      catch(Err e)
        e.trace
    }
    services.each{ it.uninstall }
  }

  ** read command line input
  Void processInput(Service[] services, |Str->Bool|? f := null)
  {
    while(true)
    {
      s := Env.cur.in.readLine
      if (s == "quit" || s == "exit")
      {
        uninstallService(services)
        Env.cur.exit
      }
      else if(f != null)
      {
        if (!f(s)) return
      }
      else
      {
        echo("input 'quit' to exit")
      }
    }
  }
}