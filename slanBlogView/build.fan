using build
class Build : build::BuildPod
{
  new make()
  {
    podName = "slanBlogView"
    summary = ""
    srcDirs = [`fan/`, `action/`]
    depends = ["sys 1.0","slanweb 1.0","slandao 1.0","web 1.0","slanBlog 1.0"]
  }
}
