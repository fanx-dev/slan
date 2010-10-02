using web
**
** default page
** 
class Index: Weblet
{
  override Void onGet()
  {
    res.headers["Content-Type"] = "text/html; charset=utf-8"
    
    res.out.html.
      h1().w("WELCOME!").h1End.br.
    
      a(`/action/Welcome/ad`).w("/action/Welcome/ad").aEnd.br.
      a(`/action/welcome/ad/printInfo?i=123&m=bac`).w("/action/welcome/ad/printInfo?i=123&m=bac").aEnd.br.
      a(`/public/index.html`).w("/public/index.html").aEnd.br.
      a(`/action/tableView`).w("/action/tableView").aEnd.br.
      a(`/action/tableView/welcome`).w("/action/tableView/welcome").aEnd.br.
    
    htmlEnd
  }
}
