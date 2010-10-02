using build
class Build : build::BuildPod
{
  new make()
  {
    podName = "slanBlog"
    summary = ""
    srcDirs = [`test/`, `test/po/`, `fan/`, `fan/po/`]
    depends = ["sys 1.0+","slandao 1.0","sql 1.0"]
  }
}
