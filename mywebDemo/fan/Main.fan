//
// Copyright (c) 2010 Yang Jiandong
// Licensed under Eclipse Public License version 1.0
//
// History:
//   yangjiandong 2010-10-27 - Initial Contribution
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
      pod:=Main#.pod
      SlanService{
          logDir=pod.config("logDir","log/").toUri
          port=pod.config("port","8080").toInt
      }.run
    }
}
