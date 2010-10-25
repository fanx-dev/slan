//
// Copyright (c) 2010, Yang Jiandong
// Licensed under the Academic Free License version 3.0
//
// History:
//   2010-9-22  Yang Jiandong  Creation
//
using web
using concurrent
**
** enhanced Weblet.convenience for rendering template.
**
mixin SlanWeblet
{
//////////////////////////////////////////////////////////////////////////
// Request/Response
//////////////////////////////////////////////////////////////////////////
  
  **
  ** The WebReq instance for this current web request.  Raise an exception
  ** if the current actor thread is not serving a web request.
  **
  WebReq req()
  {
    try
      return Actor.locals["web.req"]
    catch (NullErr e)
      throw Err("No web request active in thread")
  }

  **
  ** The WebRes instance for this current web request.  Raise an exception
  ** if the current actor thread is not serving a web request.
  **
  WebRes res()
  {
    try
      return Actor.locals["web.res"]
    catch (NullErr e)
      throw Err("No web request active in thread")
  }
  
//////////////////////////////////////////////////////////////////////////
// template method
//////////////////////////////////////////////////////////////////////////
  
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

//////////////////////////////////////////////////////////////////////////
// template method
//////////////////////////////////////////////////////////////////////////
  
  ** text/html; charset=utf-8
  Void writeContentType(){
    req.session
    res.headers["Content-Type"] = "text/html; charset=utf-8"
  }
  
  ** go back to referer uri
  Void back(){
    Str uri:=req.headers["Referer"]
    res.redirect(uri.toUri)
  }
  
  ** convert method to uri
  Uri toUri(Type type,Str? id:=null,Method? method:=null){
    uri:="/action/$type.name"
    if(id!=null){
      uri+="/$id"
    }
    if(method!=null){
      uri+="/$method.name"
    }
    return uri.toUri
  }
  
  ** #toUri and res.redirect
  Void redirect(Type type,Str? id:=null,Method? method:=null){
    res.redirect(toUri(type,id,method))
  }
  
  ** req.stash
  const static ReqStash m:=ReqStash()
}