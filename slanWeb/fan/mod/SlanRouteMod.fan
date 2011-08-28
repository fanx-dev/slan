//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

using webmod
using web
using concurrent

**
** Route for all Mod
**
const class SlanRouteMod : WebMod
{
  private const static Str publics := "public"
  private const static Str actions := "action"
  private const Uri errorPage := `/$publics/error.html`
  private const SlanApp slanApp

  ** Map of URI path names to sub-WebMods.
  const Str:WebMod routes

  new make(SlanApp slanApp)
  {
    this.slanApp = slanApp
    routes =
    [
      actions : ActionMod(slanApp, `fan/$actions/`),
      "pod" : PodJsMod(),
      "jsfan" : JsfanMod(slanApp, `fan/jsfan/`),
      publics : StaticFileMod(slanApp, `$publics/`),
    ]
  }

  override Void onService()
  {
    try
    {
      doService
    }
    catch (Err err)
    {
      onErro(err)
    }
  }

  private Void doService()
  {
    // get the next name in the path
    name := req.modRel.path.first

    //lookup Mod
    mod := findMod(name)
    if (mod == null) { res.sendErr(404); return }

    //execute
    req.mod = mod
    mod.onService
  }

  **
  ** lookup route
  **
  private WebMod? findMod(Str? name)
  {
    //default mod
    if (name == null)
    {
      return routes[actions]
    }

    //favicon mod
    if (name == "favicon.ico")
    {
      return routes[publics]
    }

    //normal mod
    route := routes[name]

    //deepInto
    if (route != null)
    {
      req.modBase = req.modBase + `$name/`
      return route
    }

    //default mod
    return routes[actions]
  }

  override Void onStart()
  {
    routes.each |mod| { mod.onStart }
  }

  override Void onStop()
  {
    routes.each |mod| { mod.onStop }
  }

//////////////////////////////////////////////////////////////////////////
// error
//////////////////////////////////////////////////////////////////////////

  ** trace errInfo
  private Void onErro(Err err)
  {
    if (req.absUri.host == "localhost" || !slanApp.isProductMode)
    {
      //show error on debug mode
      showErr(err)
    }
    else if (req.uri.relToAuth == errorPage)
    {
      //error page not found
      msg := "sorry! don't find error page $errorPage .by slanweb"
      if (!res.isCommitted)
        res.sendErr(500, msg)
      else
        res.out.w(msg)
    }
    else
    {
      //to error page
      err.trace
      this.res.redirect(errorPage)
    }
  }

  private Void showErr(Err err)
  {
    if (res.isCommitted && !res.isDone)
    {
      res.out.print("<p>ERROR: $req.uri</p>")
      res.out.w(err.traceToStr.replace("\n","<br/>"))
    }
    else if (err is SlanCompilerErr)
    {
      res.statusCode = 500
      res.headers.clear
      res.headers["Content-Type"] = "text/html; charset=utf-8"
      res.out.print(err->dump)
      return
    }
    throw err
  }
}