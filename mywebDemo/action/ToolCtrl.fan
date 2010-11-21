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
class ToolCtrl : SlanWeblet
{
  @WebGet
  Void patchca() {}

  Void image()
  {
    req.session // init session
    res.headers["Content-Type"] = "image/jpg"
    patchca := Patchca{}
    code := patchca.create(res.out)
    req.session["code"] = code
  }

  @WebPost
  Void validate(Str code)
  {
    ocode := req.session["code"]
    message := code.equalsIgnoreCase(ocode) ? "right" : "wrong"
    writeContentType
    res.out.w(message)
  }
}