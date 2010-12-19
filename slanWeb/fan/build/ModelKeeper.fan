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

**
** modle code change detective
**
const class ModelKeeper : Weblet
{
  private const SlanApp slanApp

  **
  ** store lastNoted time
  **
  private const AtomicRef lastNoted := AtomicRef()

  **
  ** build.fan compiler
  **
  private const BuildCompiler buildCompiler

  new make(SlanApp slanApp)
  {
    this.slanApp = slanApp
    this.buildCompiler = BuildCompiler(slanApp)
  }

  **
  ** rebuild pod if necessary
  **
  Void loadChange()
  {
    if (slanApp.isProductMode) return
    rebuild
  }

  private Void rebuild()
  {
    DateTime? lastTime :=  lastNoted.val

    //now not need rebuid it, because we build the pod on service started
    if(lastTime == null)
    {
      lastNoted.getAndSet(DateTime.now)
      return
    }

    appHome := slanApp.appHome
    if (modelChanged(appHome, lastTime))
    {
       slanApp.scriptCompiler.clearCache
       podName := buildCompiler.runBuild(`${appHome}build.fan`.toFile)
       lastNoted.getAndSet(DateTime.now)
       slanApp.setPodName(podName)
    }
  }

  private Bool modelChanged(Uri appHome, DateTime lastNoted){
    return isFolderChanged(File(appHome + `fan/model/`), lastNoted) ||
           isFolderChanged(File(appHome + `fan/util/`), lastNoted)
  }

  **
  ** these code from tales
  **
  private Bool isFolderChanged(File folder, DateTime lastNoted)
  {
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

