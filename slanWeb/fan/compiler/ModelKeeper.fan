//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-12-4  Jed Young  Creation
//

using build
using web
using wisp
using concurrent

internal const class ModelKeeper : Weblet
{
  private static const SingletonMap map := SingletonMap()

  ** return false to interception
  Bool loadChange()
  {
    if (Config.cur.isProductMode) return true

    DateTime? lastNoted :=  map["lastNoted"]
    if (lastNoted == null)
    {
      map["lastNoted"] = DateTime.now
      return true
    }

    appHome := Config.cur.getAppHome

    if (modelChanged(appHome, lastNoted))
    {
       restart
       return false
    }
    return true
  }

  ** restart process
  private Void restart()
  {
     res.headers["Content-Type"] = "text/html; charset=utf-8"
     res.out.w(Str<|
                    <html>
                     <head>
                      <script language="javascript">
                        function opencolortext(){ window.location.reload() }
                        setTimeout("opencolortext()",5000)
                      </script>
                     </head>
                     <body>
                       <h1>Service restarting... This page will refresh after 5sec</h1>
                     </body>
                    <html>
                   |>)
     res.out.flush

     a := Actor(ActorPool()) |msg|
     {
       //rebuild
       BuildPod build := Config.cur.getBuildScript
       build.main(Str[,])

       //stop service
       Service.find(WispService#).stop.uninstall

       //will start other process to run
       Env.cur.exit(2025)
       return null
     }
     a.sendLater(1sec, null)
  }

  private Bool modelChanged(Uri appHome, DateTime? lastNoted){
    return isFolderChanged(File(appHome + `fan/`), lastNoted)
  }

  **
  ** these code from tales
  **
  private Bool isFolderChanged(File folder, DateTime? lastNoted)
  {
    if (lastNoted == null)
    {
      //we can return true here, but if there are no files, we should return false
      lastNoted = DateTime.now + (- 5000day)
    }

    File[] toReturn := File[,]
    folder.walk |File f|{
      if( (!f.isDir) && (f.ext == "fan")){
        if(f.modified > lastNoted){
          toReturn.add(f)
        }
      }
    }
    return (toReturn.size>0)
  }
}

