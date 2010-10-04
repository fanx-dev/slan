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
class CommentCtrl:SlanWeblet
{
  CommentService commentSer:=ServiceFactory.cur.commentService
  
  @WebMethod{type="POST"}
  Void create(Int postId,Str text){
    u:=req.session["user"]
    if(u==null){
      req.session["message"]="please login"
      res.redirect(`/action/Log`)
      return
    }
    commentSer.create(postId,u,text)
    
    res.redirect(`/action/User/$u`)
  }
  
  @WebMethod
  Void delete(Int id){
    u:=req.session["user"]
    if(u==null){
      req.session["message"]="please login"
      res.redirect(`/action/Log`)
      return
    }
    commentSer.delete(u,id)
    
    res.redirect(`/action/User/$u`)
  }
}
