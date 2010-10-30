
internal class HtmlTemComTest:Test
{
  Void test(){
    Pod.of(this).log.level=LogLevel.debug
    TemplateCompiler c:=TemplateCompiler.instance
    c.getType(`fan://slanweb/res/welcome.html`.get)
    Pod.of(this).log.level=LogLevel.info
  }
}
