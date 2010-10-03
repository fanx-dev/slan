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
class CommentRes:SlanWeblet
{
  @WebMethod{type="POST"}
  Void create(Int postId,Str text){
    u:=req.session["user"]
    if(u==null){
      req.session["message"]="please login"
      res.redirect(`/action/Log`)
      return
    }
    Comment.create(postId,u,text)
    
    res.redirect(`/action/UserRes/$u`)
  }
  
  @WebMethod
  Void delete(Int id){
    u:=req.session["user"]
    if(u==null){
      req.session["message"]="please login"
      res.redirect(`/action/Log`)
      return
    }
    User.get(u).deleteComment(id)
    
    res.redirect(`/action/UserRes/$u`)
  }
}
