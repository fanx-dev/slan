//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

using web

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
  private const DefaultWeblet defaultWeblet
  private const ModelKeeper modelKeeper

  **
  ** dir:action directory
  **
  new make(Uri dir)
  {
    this.dir = dir
    defaultWeblet = DefaultWeblet()
    modelKeeper = ModelKeeper()
  }

  override Void onService()
  {
    //rewrite uri
    path := convertPath(req.modRel.path)
    if (path.size == 0)
    {
      throw Err("path is empty.Maybe some errors on convertPath")
    }

    onActionFile(path)
  }

  ** find and call
  private Void onActionFile(Str[] path)
  {
    modelKeeper.loadChange
    location := ActionLocation(dir).execute(path)
    defaultWeblet.execute(location)
  }

  **
  ** trap for url rewrite
  **
  protected virtual Str[] convertPath(Str[] inPath)
  {
    if (inPath.size == 0)
    {
      return ["IndexCtrl"]
    }

    Str[] path := inPath.dup

    Str typeName := path[0]
    if (typeName.endsWith("Ctrl"))
    {
      path[0] = typeName.capitalize
    }
    else
    {
      //suffix Ctrl
      path[0] = (typeName + "Ctrl").capitalize
    }
    return path
  }

}