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
internal const class ModelKeeper : Weblet
{
  private static const SingletonMap map := SingletonMap()

  **
  ** rebuild pod if necessary
  **
  Void loadChange()
  {
    if (Config.cur.isProductMode) return

    DateTime? lastNoted :=  map["lastNoted"]
    appHome := Config.cur.getAppHome

    if (modelChanged(appHome, lastNoted))
    {
       ScriptCompiler.cur.clearCache
       Config.cur.rebuild
       map["lastNoted"] = DateTime.now
    }
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

