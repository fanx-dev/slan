// To change this License template, choose Tools / Templates
// and edit Licenses / FanDefaultLicense.txt
//
// History:
//   2010-9-4 yangjiandong Creation
//

**
** MyWebUtilTest
**
internal class WebUtilTest:Test
{
  Void m4test(Int i,Str s){}

  Void testGetParams(){
    objs:=SlanUtil.getParams(["action","welcom","123","p2"],
      #m4test.params,2)
    this.verify(objs.size==2)
    this.verify(objs[0]==123)
    this.verify(objs[1]=="p2")

    #m4test.callOn(this,objs)
  }

  Void testGetParamsByName(){
    objs:=SlanUtil.getParamsByName(["s":"p2"],
      #m4test.params,["i":"123"])
    this.verify(objs.size==2)
    this.verify(objs[0]==123)
    this.verify(objs[1]=="p2")

    #m4test.callOn(this,objs)
  }
}