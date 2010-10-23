//
// Copyright (c) 2008, Brian Frank and Andy Frank
// Licensed under the Academic Free License version 3.0
//
// History:
//   27 Nov 08  Brian Frank  Creation
//   2010-9-22  Yang Jiandong  Modify
//
using webmod
using web

** RouteMod added error dispose
const class SlanRouteMod : WebMod
{
  **
  ** Constructor with it-block.
  **
  new make(|This|? f)
  {
    f?.call(this)
    if (routes.isEmpty) throw ArgErr("RouteMod.routes is empty")
  }

  **
  ** Map of URI path names to sub-WebMods.  The name "index"
  ** is used for requests to the RouteMod itself.
  **
  const Str:WebMod routes := Str:WebMod[:]
  const Uri errorPage:=`/public/error.html`
  const Str defaultMod:="action"

  private Void doService()
  {
    // get the next name in the path
    name := req.modRel.path.first
    
    // lookup route
    WebMod? route
    if(name!=null){
      route=routes[name]
      if(route!=null){
        //all thing ok
        req.modBase = req.modBase + `$name/`
        req.mod = route
        route.onService
        return
      }
    }
    
    //try defaultMod
    route=routes[defaultMod]
    if (route == null){ res.sendErr(404); return }
    req.mod = route
    route.onService
  }

  override Void onStart() { routes.each |mod| { mod.onStart } }
  override Void onStop() { routes.each |mod| { mod.onStop } }

  override Void onService()
  {
    try{
      doService
    }catch(Err err){
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
}