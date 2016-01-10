//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

using web
using slanWeb
using slanUtil

**
** slanUtil
**
class Patchca : SlanWeblet
{
  @WebGet
  Void patchca() { render }

  Void image()
  {
    req.session // init session
    res.headers["Content-Type"] = "image/jpg"
    patchca := slanUtil::Patchca{}
    code := patchca.create(res.out)
    req.session["code"] = code
  }

  @WebPost
  Str validate(Str code)
  {
    ocode := req.session["code"]
    if (ocode == null || ocode == "") return "wrong"
    message := code.equalsIgnoreCase(ocode) ? "right" : "wrong"
    return message
  }
}