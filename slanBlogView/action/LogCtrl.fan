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
class LogCtrl : SlanWeblet
{
  LogService logSer:=ServiceFactory.cur.logService
  
  override Void onGet(){
    writeContentType
    render(`view/login.html`)
  }
  
  @WebMethod{type="POST"}
  Void login(Str username,Str password){
    u:=logSer.login(username,password)
    if(u!=null){
      req.session["user"]=u.id
      req.session["message"]="welcome back $u.id"
      res.redirect(`/action/User/$u.id`)
    }else{
      req.session["message"]="password or username error"
      onGet
    }
  }
  
  @WebMethod
  Void logout(){
    req.session["user"]=null
    req.session["message"]="good bye"
    onGet
  }
  
  @WebMethod
  Void logupView(){
    writeContentType
    render(`view/logup.html`)
  }
  
  @WebMethod{type="POST"}
  Void logup(Str username,Str password,Str email){
    u:=logSer.logup(username,password,email)
    if(u!=null){
      req.session["user"]=u.id
      req.session["message"]="logup successfully"
      res.redirect(`/action/User/$u.id`)
    }else{
      req.session["message"]="userName is conflict"
      logupView
    }
  }
}
