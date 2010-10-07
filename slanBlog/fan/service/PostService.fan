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
const class PostService : MyContext
{
  Post[] listByUser(Str userId){
    c.ret{
      Post.list(userId)
    }
  }
  
  Post create(Str userId,Str text){
    c.ret{
      Post.create(userId,text)
    }
  }
  
  Void delete(Str userId,Int postId){
    c.trans{
      Post.get(postId).deleteMe
    }
  }
}
