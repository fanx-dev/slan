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
  static Post? fromPo(PostPo? p){
    if(p==null)return null
    return Post{id=p.id;text=p.text;dt=p.dt;author=p.author}
  }
  
  static Post[] list(Str userId){
    PostPo[] ps:= PostPo{author=userId}.select
    return ps.map{fromPo(it)}
  }
  
  static Post create(Str userId,Str text){
    p:= PostPo{author=userId;it.text=text;dt=DateTime.now;point=0}.insert
    return fromPo(p)
  }
  
  static Post get(Int id){
    p:= c.findById(PostPo#,id)
    return fromPo(p)
  }
  
  static Void delete(Int id){
    PostPo{it.id=id}.delete
  }
}
