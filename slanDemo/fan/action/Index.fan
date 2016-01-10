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
    setContentType("html")

    res.out.html.
      head.title.w("slan sample").titleEnd.headEnd.
      h1.w("Slan Web Framework").h1End.

      h2.w("Base Examples").h2End.
      a(`/Base/printInfo/test?i=123&m=bac`).w("/Base/printInfo/test?i=123&m=bac").aEnd.br.
      a(`/Base/template/Slan`).w("/Base/template/Slan").aEnd.br.
      a(`/Base/fwt`).w("/Base/fwt").aEnd.br.

      h2.w("JS FWT").h2End.
      a(`/jsfan/TableFwt.fan`).w("/jsfan/TableFwt.fan").aEnd.br.

      h2.w("XML").h2End.
      a(`/Xml/data.xml`).w("/Xml/data.xml").aEnd.br.
      a(`/Xml/data.html`).w("/Xml/data.html").aEnd.br.

      h2.w("REST").h2End.
      a(`/Rest`).w("/Rest").aEnd.br.

      h2.w("i18n").h2End.
      a(`/Localization`).w("/Localization").aEnd.br.

      h2.w("slanUtil").h2End.
      a(`/Patchca/patchca`).w("/Tool/patchca").aEnd.br.
      a(`/Upload/upload`).w("/Tool/upload").aEnd.br.

      h2.w("Other").h2End.
      a(`/Index/dump`).w("RequestHeaders").aEnd.br.

    htmlEnd
  }

  Void dump()
  {
    setContentType
    req.headers.each |Str v, Str k| { res.out.printLine("$k: $v") }
  }
}