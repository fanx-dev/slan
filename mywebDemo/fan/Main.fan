// To change this License template, choose Tools / Templates
// and edit Licenses / FanDefaultLicense.txt
//
// History:
//   2010-6-27 yangjiandong Creation
//
using slanweb
**
** Main
**
class Main
{
    static Void main()
    {
        //hack
        Config.instance.podName=Main#.pod.name
        run
    }
  
    static Void run(){
      SlanService{
          logDir=`log/`
          port=8080
          route=SlanRouteMod
          {
            routes=
            [
              "action":MyActionMod(`action/`),
              "public":StaticFileMod(`public/`),
              "pod":PodJsMod()
            ]
          }
      }.run
    }
}

**
** add authorized
**
const class MyActionMod:ActionMod{
  new make(Uri dir):super(dir){}
  
  protected override Bool beforeInvoke(Type type,Method method){
    //rejection 'welcome' method
    if(method.name=="welcome")return false
    return true
  }
}