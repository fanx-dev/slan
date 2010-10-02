
internal class HtmlTemComTest:Test
{
  Void test(){
    TemplateCompiler c:=TemplateCompiler.instance
    c.getType(`fan://slanweb/res/welcome.html`.get)
  }
}
