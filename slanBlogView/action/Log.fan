//
// Copyright (c) 2010 Yang Jiandong
// Licensed under Eclipse Public License version 1.0
//
// History:
//   yangjiandong 2010-10-2 - Initial Contribution
//

using slanweb
using slanBlog
**
**
**
class Log : SlanWeblet
{
  override Void onGet(){
    req.stash["message"]=req.session["message"]
    req.session["message"]=null
    
    writeContentType
    render(`view/login.html`)
  }
  
  @WebMethod{type="POST"}
  Void login(Str username,Str password){
    u:=UserService().login(username,password)
    if(u!=null){
      req.session["user"]=u
      res.redirect(`/`)
    }else{
      req.session["message"]="password or username error"
      onGet
    }
  }
  
  @WebMethod
  Void logout(){
    req.session["user"]=null
    onGet
  }
  
  @WebMethod
  Void logupView(){
    req.stash["message"]=req.session["message"]
    req.session["message"]=null
    
    writeContentType
    render(`view/logup.html`)
  }
  
  @WebMethod{type="POST"}
  Void logup(Str username,Str password,Str email){
    u:=UserService().logup(username,password,email)
    if(u!=null){
      req.session["user"]=u
      res.redirect(`/`)
    }else{
      req.session["message"]="userName is conflict"
      logupView
    }
  }
}
