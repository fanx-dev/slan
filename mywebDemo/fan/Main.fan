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
        //run on pod mode
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
              "action":ActionMod(`action/`),
              "public":StaticFileMod(`public/`),
              "pod":PodJsMod()
            ]
          }
      }.run
    }
}
