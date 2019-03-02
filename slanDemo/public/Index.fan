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
  Void get()
  {
    setContentType("html")

    res.out.html.
      head.title.w("slan sample").titleEnd.headEnd.
      h1.w("Slan Web Framework").h1End.

      h2.w("Base Examples").h2End.
      a(`/base/Rpc/printInfo/test?a=1&b=2`).w("/base/Rpc/printInfo/test?a=1&b=2").aEnd.br.
      a(`/base/Localization.fsp`).w("/base/Localization.fsp").aEnd.br.
      a(`/base/Rest`).w("/base/Rest").aEnd.br.
      a(`/PodTest`).w("/PodTest").aEnd.br.

      h2.w("Template Test").h2End.
      a(`/template/Template/abc`).w("/template/Template/abc").aEnd.br.
      a(`/template/Xml/data.xml`).w("/template/Xml/data.xml").aEnd.br.
      a(`/template/Xml/data.html`).w("/template/Xml/data.html").aEnd.br.

      h2.w("Javascript").h2End.
      a(`/fanJs/EmbedJs/js`).w("/fanJs/EmbedJs/js").aEnd.br.
      a(`/fanJs/Hello.fwt`).w("/fanJs/Hello.fwt").aEnd.br.

      h2.w("Util").h2End.
      a(`/util/Patchca/patchca`).w("/util/Patchca/patchca").aEnd.br.
      a(`/util/Upload/upload`).w("/util/Upload/upload").aEnd.br.

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