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
** only for pod's javascript file
**
const class PodJsMod : WebMod
{
  override Void onService()
  {
    //this is only valid for javascript file
    if(req.modRel.ext == "apidoc" || req.modRel.ext == "def")
    {
      res.sendErr(403)
      return
    }
    File? file
    try
      file = ("fan://" + req.modRel).toUri.get
    catch
    {
      res.sendErr(404)
      return
    }
    FileWeblet(file).onService
  }
}