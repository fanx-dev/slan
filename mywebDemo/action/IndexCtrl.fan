using web
**
** default page
** 
class IndexCtrl: Weblet
{
  Void get()
  {
    res.headers["Content-Type"] = "text/html; charset=utf-8"
    
    res.out.html.
      h1().w("WELCOME!").h1End.br.
    
      a(`/Welcome`).w("/Welcome").aEnd.br.
      a(`/action/Welcome/welcome`).w("/action/Welcome/welcome").aEnd.br.
      a(`/action/Welcome/printInfo/apdb?i=123&m=bac`).w("/action/Welcome/printInfo/apdb?i=123&m=bac").aEnd.br.
      a(`/action/TableView`).w("/action/TableView").aEnd.br.
      a(`/action/Welcome/fwt`).w("/action/Welcome/fwt").aEnd.br.
    
    htmlEnd
  }
}
