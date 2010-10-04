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
mixin PostDao : MyContext
{
  static Post[] list(Str userId){
    Post{author=userId}.select
  }
  
  static Post create(Str userId,Str text){
    Post{author=userId;it.text=text;dt=DateTime.now;point=0}.insert
  }
  
  static Post get(Int id){
    c.findById(Post#,id)
  }
}
