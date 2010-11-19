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
  Void index()
  {
    res.headers["Content-Type"] = "text/html; charset=utf-8"

    res.out.html.
      h1().w("Slan Framework").h1End.br.

      a(`/Welcome`).w("/Welcome").aEnd.br.
      a(`/action/Welcome/welcome`).w("/action/Welcome/welcome").aEnd.br.
      a(`/action/Welcome/printInfo/apdb?i=123&m=bac`).w("/action/Welcome/printInfo/apdb?i=123&m=bac").aEnd.br.
      a(`/action/TableView`).w("/action/TableView").aEnd.br.
      a(`/action/Welcome/fwt`).w("/action/Welcome/fwt").aEnd.br.

    htmlEnd
  }
}