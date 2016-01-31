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

  **
  ** dir:action directory
  **
  new make(Uri dir)
  {
    this.dir = dir
  }

  override Void onService()
  {
    //checkReferer
    paths := pathArray(req.modRel)
    typeName := paths.first
    slanApp := SlanApp.cur
    consume := false
    Type? type
    if (typeName != null) {
      type = slanApp.findType(typeName, dir, false)
    }

    if (type != null) {
      consume = true
    } else {
      type = slanApp.findType("Index", dir, false)
    }

    if (type == null) {
      res.sendErr(404)
      return
    }

    if (consume) {
      if (paths.size > 1) {
        req.stash["_paths"] = paths[1..-1]
      }
    } else {
      req.stash["_paths"] = paths
    }

    obj := type.make() as Weblet
    if (obj == null) {
      res.sendErr(404)
      return
    }

    obj.onService
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
}