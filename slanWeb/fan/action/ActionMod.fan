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
      type = slanApp.getType(typeName, dir, false)
    }

    if (type != null) {
      consume = true
    } else {
      type = slanApp.getType("Index", dir, false)
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

    obj := type.make()
    locale.use {
      if (obj is Weblet) {
        (obj as Weblet).onService
      }
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

  **
  ** build-in locale
  **
  private Locale? locale()
  {
    acceptLang := req.headers["Accept-Language"]
    if (acceptLang == null || acceptLang == "") return null

    localeStr := acceptLang.split(';').first
    localeStr = localeStr.split(',').first
    list := localeStr.split('-')

    lang := list.first.lower
    country := list.last.upper
    locale := "$lang-$country"

    return Locale.fromStr(locale, false)
  }
}