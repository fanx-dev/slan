#! /usr/bin/env fan
//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

using build
using slanWeb

class Build : build::BuildPod
{
  new make()
  {
    podName = "slanDemo"
    summary = "it's demo for slanweb"
    srcDirs = [`fan/`]
    depends =
    [
      "sys 2.0", "std 1.0",
      "webmod 1.0",
      "web 1.0",
      "concurrent 1.0",
      "slanWeb 1.0",
      "slanUtil 1.0",
      "util 1.0",
      "dom 1.0",
      "domkit 1.0",
    ]

    resDirs =
    [
      `locale/`,
    ]
    .addAll(allDir(scriptDir.uri, `res/`))
  }

  @Target { help = "build my app as a single JAR dist" }
  Void dist()
  {
    dist := JarDist(this)
    dist.outFile = scriptDir+`war/WEB-INF/lib/slanDemo.jar`
    dist.podNames = Str["concurrent", "compiler", "build",
                        "inet", "web", "webmod", "wisp", "util",
                        "dom", "gfx", "fwt", "compilerJs",
                        "slanActor", "slanCompiler", "slanWeb", "slanUtil", "slanDemo", "servlet"]
    dist.mainMethod = "slanDemo::RootMod.init"
    dist.run
  }

  static Uri[] allDir(Uri base, Uri dir)
  {
    Uri[] subs := [,]
    (base + dir).toFile.walk |File f|
    {
      if(f.isDir)
      {
        rel := f.uri.relTo(base)
        subs.add(rel)
      }
    }
    return subs
  }

}