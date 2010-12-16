//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

using web

**
** default page
**
class IndexCtrl : Weblet
{
  ** home page
  Void index()
  {
    //error uri may be route to here
    if (req.stash["_stashId"] != null) { res.sendErr(404); return }

    res.headers["Content-Type"] = "text/html; charset=utf-8"

    res.out.html.
      h1.w("Slan Framework").h1End.

      h2.w("Base Examples").h2End.
      a(`/Welcome`).w("/Welcome").aEnd.br.
      a(`/action/Welcome/welcome/abc`).w("/action/Welcome/welcome/abc").aEnd.br.
      a(`/Welcome/printInfo/apdb?i=123&m=bac`).w("/Welcome/printInfo/apdb?i=123&m=bac").aEnd.br.

      h2.w("FWT and Ajax").h2End.
      a(`/jsfan/TableFwt.fan`).w("/jsfan/TableFwt.fan").aEnd.br.

      h2.w("slanUtil examples").h2End.
      a(`/Tool/patchca`).w("/Tool/patchca").aEnd.br.

      h2.w("Test").h2End.
      a(`/HotChange`).w("/HotChange").aEnd.br.

      h2.w("Other").h2End.
      a(`/doc`).w("FanDocs").aEnd.br.
      a(`/Index/dump`).w("RequestHeaders").aEnd.br.
      a(`/log/sys.log`).w("SysLog").aEnd.br.
      a(`/log/web.log`).w("WebLog").aEnd.br.

      htmlEnd
  }

  Void dump()
  {
    res.headers["Content-Type"] = "text/plain; charset=utf-8"
    req.headers.each |Str v, Str k| { res.out.printLine("$k: $v") }
  }
}