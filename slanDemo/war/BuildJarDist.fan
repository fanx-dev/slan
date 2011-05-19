#! /usr/bin/env fan
//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

using build

class Build : BuildScript
{
  @Target { help = "build my app as a single JAR dist" }
  Void dist()
  {
    dist := JarDist(this)
    //dist.outFile = `./ROOT/WEB-INF/lib/myapp_deploy.jar`.toFile.normalize
    dist.outFile = `file:/D:/Develop/java/Tomcat/apache-tomcat-6.0.20-2/apache-tomcat-6.0.20/webapps/ROOT/WEB-INF/lib/slanSample.jar`.toFile.normalize
    dist.podNames = Str["slanDemo", "servlet", "web", "webmod", "util", "build", "dom", "gfx", "fwt",
                        "inet", "concurrent", "compiler", "wisp", "slanWeb", "slanUtil", "compilerJs"]
    dist.mainMethod = "slanDemo::Main.init"
    dist.run
  }
}