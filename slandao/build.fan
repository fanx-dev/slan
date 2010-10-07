using build
class Build : build::BuildPod
{
  new make()
  {
    podName = "slandao"
    summary = "slan ORM"
    srcDirs = [`test/`, `test/maker/`, `test/cache/`, `test/base/`, `fan/`, `fan/sql/`, `fan/model/`, `fan/model/dialect/`, `fan/cache/`]
    depends = ["sys 1.0","sql 1.0","concurrent 1.0"]
  }
}
