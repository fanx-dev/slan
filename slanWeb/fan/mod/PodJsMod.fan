//
// Copyright (c) 2010, Yang Jiandong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Yang Jiandong  Creation
//
using webmod
using web
**
** only for pod's javascript file
**
const class PodJsMod:WebMod
{
  override Void onService()
  {
    if(req.modRel.ext!="js"){
      res.sendErr(403)
      return
    }
    file := ("fan://" + req.modRel).toUri.get
    FileWeblet(file).onService
  }
}
