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
class PostRes:SlanWeblet
{
  @WebMethod{type="POST"}
  Void create(Str text){
    u:=req.session["user"]
    if(u==null){
      res.redirect(`/action/Log`)
      return
    }
    User.get(u).createPost(text)
    res.redirect(`/action/UserRes/$u`)
  }
  
  @WebMethod
  Void delete(Int id){
    u:=req.session["user"]
    if(u==null){
      res.redirect(`/action/Log`)
      return
    }
    Post.get(id).delete(User.get(u))
    
    res.redirect(`/action/UserRes/$u`)
  }
}
