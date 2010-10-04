//
// Copyright (c) 2010 Yang Jiandong
// Licensed under Eclipse Public License version 1.0
//
// History:
//   yangjiandong 2010-10-3 - Initial Contribution
//

using slanweb
using slanBlog
**
**
**
class PostCtrl:SlanWeblet
{
  PostService postSer:=ServiceFactory.cur.postService
  
  @WebMethod{type="POST"}
  Void create(Str text){
    u:=req.session["user"]
    if(u==null){
      res.redirect(`/action/Log`)
      return
    }
    postSer.create(u,text)
    res.redirect(`/action/User/$u`)
  }
  
  @WebMethod
  Void delete(Int id){
    u:=req.session["user"]
    if(u==null){
      res.redirect(`/action/Log`)
      return
    }
    postSer.delete(u,id)
    
    res.redirect(`/action/User/$u`)
  }
}
