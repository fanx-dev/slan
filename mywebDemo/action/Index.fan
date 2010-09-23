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
      h1().w("WELCOME!").h1End.
    htmlEnd
  }
}
