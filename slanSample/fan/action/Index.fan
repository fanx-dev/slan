//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

using web
using slanWeb

**
** default page
**
class Index : SlanWeblet
{
  ** home page
  Void index()
  {
    //error uri may be route to here
    if (req.stash["_stashId"] != null) { res.sendErr(404); return }

    setContentType("html")

    res.out.html.
      head.title.w("slan sample").titleEnd.headEnd.
      h1.w("Slan Framework").h1End.

      h2.w("Base Examples").h2End.
      a(`/Base`).w("/Base").aEnd.br.
      a(`/action/Base/welcome/Akoufiky`).w("/action/Base/welcome/Akoufiky").aEnd.br.
      a(`/Base/printInfo/apdb?i=123&m=bac`).w("/Base/printInfo/apdb?i=123&m=bac").aEnd.br.

      h2.w("FWT and Ajax").h2End.
      a(`/jsfan/TableFwt.fan`).w("/jsfan/TableFwt.fan").aEnd.br.

      h2.w("XML").h2End.
      a(`/action/Xml/data.xml`).w("/action/Xml/data.xml").aEnd.br.
      a(`/action/Xml/data.html`).w("/action/Xml/data.html").aEnd.br.

      h2.w("i18n").h2End.
      a(`/Localization`).w("/Localization").aEnd.br.

      h2.w("slanUtil").h2End.
      a(`/Tool/patchca`).w("/Tool/patchca").aEnd.br.
      a(`/Tool/upload`).w("/Tool/upload").aEnd.br.

      h2.w("Test").h2End.
      a(`/HotSwap`).w("/HotSwap").aEnd.br.

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