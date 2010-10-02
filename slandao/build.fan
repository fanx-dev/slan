using build
class Build : build::BuildPod
{
  new make()
  {
    podName = "slandao"
    summary = "slan orm"
    srcDirs = [`test/`, `test/maker/`, `test/cache/`, `test/base/`, `fan/`, `fan/model/`, `fan/maker/`, `fan/cache/`]
    depends = ["sys 1.0","sql 1.0","concurrent 1.0"]
  }
}
