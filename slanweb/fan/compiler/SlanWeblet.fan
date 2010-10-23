//
// Copyright (c) 2010, Yang Jiandong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Yang Jiandong  Creation
//
using web
**
** enhanced Weblet.convenience for rendering template.
**
mixin SlanWeblet:Weblet
{
  ** text/html; charset=utf-8
  Void writeContentType(){
    req.session
    res.headers["Content-Type"] = "text/html; charset=utf-8"
  }

  ** render the template
  Void render(Uri fsp,|->|? lay:=null){
    file :=Config.getUri(fsp).get
    TemplateCompiler.instance.render(file,lay)
  }

  ** compile js file ,and set to req.stash["SlanWeblet.compileJs"]
  Void compileJs(Uri fwt,Str name:="SlanWeblet.compileJs"){
    file :=Config.getUri(fwt).get
    strBuf:=StrBuf()
    JsCompiler.render(WebOutStream(strBuf.out),file)
    req.stash[name]=strBuf.toStr
  }
  
  ** render fwt
  Void renderFwt(Uri fwt){
    file :=Config.getUri(fwt).get
    writeContentType
    JsCompiler.render(res.out,file,[:])
  }
  
  ** convenience for req.stash
  Str:Obj? s(){
    req.stash
  }
}