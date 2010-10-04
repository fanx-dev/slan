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
mixin CommentDao : MyContext
{
  static Comment create(Int postId,Str author,Str text){
    Comment{it.owner=postId;it.author=author;it.text=text;dt=DateTime.now}.insert
  }
  
  static Comment[] list(Int postId){
    Comment{it.owner=postId}.select
  }
  
  static Comment get(Int id){
    c.findById(Comment#,id)
  }
}
