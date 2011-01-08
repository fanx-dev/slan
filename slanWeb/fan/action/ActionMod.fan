//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

using web
using concurrent

**
** Action Mod
**
** see the uri 'http://localhost:8080/action/Welcome/ad/print/115?i=123&m=bac'
**  it will route to 'action'(dir) and compile 'Welcome.fan'(class),
**  then newInstance 'Welecome' with 'ad'(params).
**  call 'printInfo'(method) with 'i=123,m=bac'(named params)
**  dan set req.stash["id"]=115
**
const class ActionMod : WebMod
{
  private const Uri dir //action directory
  private const ActionRunner actionRunner
  private const SlanApp slanApp

  static const Str slanAppId := "slanWeb.ActionRunner.slanApp"

  **
  ** dir:action directory
  **
  new make(SlanApp slanApp, Uri dir)
  {
    this.slanApp = slanApp
    this.dir = dir
    actionRunner = ActionRunner()
  }

  override Void onService()
  {
    checkReferer

    //load model change
    slanApp.modelKeeper.loadChange

    //locate action
    action := ActionLocation(slanApp, dir)
    path := pathArray(req.modRel)
    if (action.parse(path))
    {
      run(action)
    }
  }

  **
  ** check Http Referer for safe
  **
  private Void checkReferer()
  {
    //GET is always allow
    if (req.method == "GET") return

    refHost := req.headers["Referer"]?.toUri?.host
    if (refHost == null || refHost != req.absUri.host)
    {
      res.sendErr(403);
    }
  }

  private Str[] pathArray(Uri rel)
  {
    ext := rel.ext
    if (ext == null) return rel.path

    //remove ext
    relStr := rel.pathStr
    dot := relStr.indexr(".")
    return relStr[0..<dot].toUri.path
  }

  ** run action
  private Void run(ActionLocation action)
  {
    Actor.locals[slanAppId] = slanApp
    try
    {
      actionRunner.execute(action)
    }
    //catch(SlanCompilerErr e)
    //{
    //  throw e
    //}
    //catch(Err e)
    //{
      //throw Err("Action error : name $action.type.name#$action.method.name,
       //           on $action.constructorParams,with $action.methodParams", e)
    //}
    finally
    {
      Actor.locals.remove(slanAppId)
    }
  }
}