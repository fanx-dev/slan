//
// Copyright (c) 2010, Yang Jiandong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Yang Jiandong  Creation
//
using web
**
** MyWebLet
**
abstract class SlanWeblet:Weblet
{
  Void writeContentType(){
    res.headers["Content-Type"] = "text/html; charset=utf-8"
  }

  Void render(Uri fsp,|->|? lay:=null){
    file :=Config.getUri(fsp).get
    TemplateCompiler.instance.render(file,lay)
  }

  Void compileJs(Uri fwt){
    file :=Config.getUri(fwt).get
    strBuf:=StrBuf()
    JsCompiler.render(WebOutStream(strBuf.out),file)
    req.stash["SlanWeblet.compileJs"]=strBuf.toStr
  }
  
  Void renderFwt(Uri fwt){
    file :=Config.getUri(fwt).get
    writeContentType
    JsCompiler.render(res.out,file,[:])
  }
}