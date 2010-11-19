//
// Copyright (c) 2010 chunquedong
// Licensed under Eclipse Public License version 1.0
//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

using slanWeb

**
** Main
**
class Main
{
    static Void main()
    {
        //run on pod mode
        Config.cur.toProductMode(Main#.pod.name)
        run
    }

    static Void run()
    {
      pod := Main#.pod
      SlanService
      {
          logDir = pod.config("logDir", "log/").toUri
          port = pod.config("port", "8080").toInt
      }.run
    }
}