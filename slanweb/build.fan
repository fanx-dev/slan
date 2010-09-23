// To change this License template, choose Tools / Templates
// and edit Licenses / FanDefaultLicense.txt
//
// History:
//   2010-9-7  yangjiandong  Creation
//
using build

**
** Build: slanweb
**
class Build : BuildPod
{
  new make()
  {
    podName = "slanweb"
    summary = "slanweb"
    depends =
    [
        "sys 1.0",
        "webmod 1.0",
        "web 1.0",
        "compiler 1.0",
        "wisp 1.0",
        "util 1.0",
        "concurrent 1.0"
    ]
    srcDirs = [`test/`, `fan/`, `fan/mod/`, `fan/com/`]
    resDirs = [`res/`]
  }
}
