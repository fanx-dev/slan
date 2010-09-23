using build
class Build : build::BuildPod
{
  new make()
  {
    podName = "slandao"
    summary = ""
    srcDirs = [`test/`, `test/maker/`, `fan/`, `fan/maker/`]
    depends = ["sys 1.0","sql 1.0","concurrent 1.0"]
  }
}
