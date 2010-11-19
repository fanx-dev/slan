//
// Copyright (c) 2010, chunquedong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Jed Young  Creation
//

using web
using compiler

**
** compile and run template file
**
const class TemplateCompiler
{

  private const Cache cache := Cache()
  private const CodeTransform codeTrans := CodeTransform()

  static const TemplateCompiler instance := TemplateCompiler()

  private new make(){}

  Void render(File file, |->|? lay := null)
  {
    type := getType(file)
    obj := type.make
    type.method("dump").call(obj, lay)
  }

  ** from cache or compile
  private Type getType(File file)
  {
    key := file.toStr
    Type? type

    //try from cache
    cacheScript := getCache(key, file)
    if (cacheScript != null)
    {
      type = Type.find(cacheScript.typeName, false)
    }

    //compile
    if (type == null)
    {
      type = compile(file)

      putCache(key, Script
        {
          modified = file.modified;
          size = file.size;
          typeName = type.qname
        })
    }
    return type
  }

  private Script? getCache(Str key, File file)
  {
    Script? c := cache[key]
    if (c == null) return null

    //remove if out date
    if (!c.eq(file))
    {
      cache.remove(key)
      return null
    }
    return c
  }

  private Void putCache(Str key, Script script)
  {
    cache[key] = script
  }

//////////////////////////////////////////////////////////////////////////
// compile
//////////////////////////////////////////////////////////////////////////

  //compile
  private Type compile(File file)
  {
    source := codeTrans.transform(file)
    Pod? pod
    try
    {
      pod = compileScript(source, file)
    }
    catch (CompilerErr e)
    {
      throw TemplateErr(e, source, file)
    }
    type := pod.type("HtmlTemplet")
    return type
  }

  //compileFantomScript
  private Pod compileScript(Str source, File file)
  {
    input := CompilerInput
    {
      it.podName  = "${file.basename}_$DateTime.nowUnique"
      summary     = "HtmlTemplet"
      isScript    = true
      version     = Version.defVal
      it.log.level   = LogLevel.warn
      output      = CompilerOutputMode.transientPod
      mode        = CompilerInputMode.str
      srcStr      = source
      srcStrLoc   = Loc.makeFile(file, 100, 100)
    }

    return Compiler(input).compile.transientPod
  }
}

**************************************************************************
** Script Cache Object
**************************************************************************

const class Script
{
  const DateTime modified;
  const Int size;
  const Str? typeName;

  Bool eq(File file)
  {
    if (this.modified != file.modified) return false
    if (this.size != file.size) return false
    return true
  }

  new make(|This| f)
  {
    f(this)
  }
}