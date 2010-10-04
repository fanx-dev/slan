//
// Copyright (c) 2010 Yang Jiandong
// Licensed under Eclipse Public License version 1.0
//
// History:
//   yangjiandong 2010-10-2 - Initial Contribution
//

using slandao
**
**
**
class User : UserDao
{
  Str id
  Role role
  new make(|This| f){ f(this) }
  
  Bool deleteComment(Int commentId){
    c:= Comment.get(commentId)
    
    //I'm admin
    if(role==Role.admin){
      c.deleteMe()
      return true
    }
    
    //I'm author
    if(c.author==id){
      c.deleteMe()
      return true
    }
    
    //my post
    p:=Post.get(c.owner)
    if(p.author==id){
      c.deleteMe()
      return true
    }
    
    return false
  }
}
