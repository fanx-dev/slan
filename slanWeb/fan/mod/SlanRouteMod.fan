//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

using webmod
using web

**
** RouteMod added error dispose
**
const class SlanRouteMod : WebMod
{
  private const static Str publics := "public"
  private const static Str actions := "action"
  private const Uri errorPage := `/$publics/error.html`
  private const SlanApp slanApp

  ** Map of URI path names to sub-WebMods.
  const Str:WebMod routes := Str:WebMod[:]

  new make(SlanApp slanApp, |[Str:WebMod]|? f := null)
  {
    this.slanApp = slanApp
    Str:WebMod map :=
    [
      actions : ActionMod(slanApp, `fan/$actions/`),
      "pod" : PodJsMod(),
      "jsfan" : JsfanMod(slanApp, `fan/jsfan/`),
      publics : StaticFileMod(slanApp, `$publics/`),
    ]
    f?.call(map)
    routes = map
  }

  override Void onService()
  {
    try
    {
      if (!beforeInvoke)
      {
        res.sendErr(401)
      }
      else
      {
        doService
      }
    }
    catch(SlanCompilerErr e)
    {
      res.headers["Content-Type"] = "text/html; charset=utf-8"
      res.out.print(e.dump)
    }
    catch (Err err)
    {
      onErro(err)
    }
    finally
    {
      afterInvoke
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

  ** lookup route
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

  ////////////////////////////////////////////////////////////////////////

  ** return false will cancle the request
  protected virtual Bool beforeInvoke() { true }

  ** guarantee will be called
  protected virtual Void afterInvoke() {}

  ////////////////////////////////////////////////////////////////////////

  override Void onStart()
  {
    routes.each |mod| { mod.onStart }
  }

  override Void onStop()
  {
    routes.each |mod| { mod.onStop }
  }

  ////////////////////////////////////////////////////////////////////////

  ** trace errInfo
  private Void onErro(Err err)
  {
    if (req.absUri.host == "localhost")
    {
      //dump errInfo
      if (res.isCommitted)
      {
        res.out.print("<p>ERROR: $req.uri</p>")
        res.out.w(err.traceToStr.replace("\n","<br/>"))
      }
      throw err
    }
    else if (req.uri.relToAuth == errorPage)
    {
      if (!res.isCommitted)
      {
        res.headers["Content-Type"] = "text/html; charset=utf-8"
      }
      res.out.w("sorry! don't find error page $errorPage .by slanweb")
    }
    else
    {
      err.trace
      this.res.redirect(errorPage)
    }
  }
}