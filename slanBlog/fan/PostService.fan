//
// Copyright (c) 2010 Yang Jiandong
// Licensed under Eclipse Public License version 1.0
//
// History:
//   yangjiandong 2010-10-2 - Initial Contribution
//


**
**
**
class PostService:MyContext
{
  Post[] getUserPosts(Str userId){
    c.ret{
      Post{author=userId}.select
    }
  }
  
  Post createPost(Str userId,Str text){
    c.ret{
      Post{author=userId;it.text=text;dt=DateTime.now;point=0}.insert
    }
  }
}
