
class HtmlTemComTest:Test
{
  Void test(){
    TempletCompiler c:=TempletCompiler.instance
    c.getType(`fan://slanweb/res/welcome.html`.get)
  }
}
