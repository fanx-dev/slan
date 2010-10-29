//
// Copyright (c) 2010 Yang Jiandong
// Licensed under Eclipse Public License version 1.0
//
// History:
//   yangjiandong 2010-10-28 - Initial Contribution
//
using webmod
using web

** RouteMod added error dispose
const class SlanRouteMod : WebMod
{
  const ActionMod actionMod
  const PodJsMod podJsMod
  const StaticFileMod staticFileMod
  const Uri errorPage

  new make()
  {
    actionMod=ActionMod(`action/`)
    podJsMod=PodJsMod()
    staticFileMod=StaticFileMod(`public/`)
    errorPage=`/public/error.html`
  }
  
  override Void onService()
  {
    try{
      if(!beforeInvoke){
        res.sendErr(401)
      }else{
        doService
      }
    }catch(Err err){
      onErro(err)
    }finally{
      afterInvoke
    }
  }

  private Void doService()
  {
    // get the next name in the path
    name := req.modRel.path.first
    
    //lookup Mod
    switchMod(name)
    
    //execute
    req.mod.onService
  }
  
  ** lookup route
  private Void switchMod(Str? name){
    switch(name){
      case "action":
        deepInto(name)
        req.mod= actionMod
      case "public":
        deepInto(name)
        req.mod= staticFileMod
      case "pod":
        deepInto(name)
        req.mod= podJsMod
      case "favicon.ico":
        req.mod= staticFileMod
      default:
        req.mod= actionMod
    }
  }
  
  private Void deepInto(Str name){
    req.modBase = req.modBase + `$name/`
  }
  
  ////////////////////////////////////////////////////////////////////////

  ** return false will cancle the request
  protected virtual Bool beforeInvoke(){
    return true
  }
  
  ** guarantee will be called
  protected virtual Void afterInvoke(){
    
  }
  
  ////////////////////////////////////////////////////////////////////////
  
  override Void onStart(){ 
    actionMod.onStart
    staticFileMod.onStart
    podJsMod.onStart
  }
  override Void onStop(){ 
    actionMod.onStop
    staticFileMod.onStop
    podJsMod.onStop
  }
  
  ////////////////////////////////////////////////////////////////////////
  
  ** trace errInfo
  private Void onErro(Err err){
    if(req.absUri.host=="localhost"){
      //dump errInfo
      if(res.isCommitted){
        res.out.print("ERROR: $req.uri<br/>")
        res.out.w(err.traceToStr.replace("\n","<br/>"))
      }
      throw err
    }else if(req.uri.relToAuth==errorPage){
      if(!res.isCommitted){
        res.headers["Content-Type"] = "text/html; charset=utf-8"
      }
      res.out.w("sorry! don't find error page $errorPage .by slanweb")
    }else{
      err.trace
      this.res.redirect(errorPage)
    }
  }
}