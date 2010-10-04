//
// Copyright (c) 2010 Yang Jiandong
// Licensed under Eclipse Public License version 1.0
//
// History:
//   yangjiandong 2010-10-4 - Initial Contribution
//


**
**
**
const class CommentService : MyContext
{
  Comment create(Int postId,Str author,Str text){
    c.ret{
    Comment.create(postId,author,text)
    }
  }
  
  Comment[] list(Int postId){
    c.ret{
    Comment.list(postId)
    }
  }
  
  Void delete(Str userId,Int id){
    c.ret{
    User.get(userId).deleteComment(id)
    }
  }
}
