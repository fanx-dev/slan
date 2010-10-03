using build
class Build : build::BuildPod
{
  new make()
  {
    podName = "slanBlog"
    summary = "a simple blog using slan"
    srcDirs = [`test/`, `test/po/`, `fan/`, `fan/utils/`, `fan/po/`, `fan/bo/`]
    depends = ["sys 1.0+","slandao 1.0","sql 1.0"]
  }
}
