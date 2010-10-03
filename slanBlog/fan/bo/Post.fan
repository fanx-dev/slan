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
class Post:MyContext
{
  Int id
  Str text
  Str author
  DateTime dt
  new make(|This| f){ f(this) }
  
  static Post? fromPo(PostPo? p){
    if(p==null)return null
    return Post{id=p.id;text=p.text;dt=p.dt;author=p.author}
  }
  
  
  Bool delete(User u){
    if(u.id!=author && u.role!=Role.admin){
      return false
    }
    c.use{
      PostPo{it.id=this.id}.delete
    }
    return true
  }
  
  Comment[] commentList(){
    Comment.list(id)
  }
  
  ////////////////////////////////////////////////////////////////////////
  //static
  ////////////////////////////////////////////////////////////////////////
  
  internal static Post[] list(Str userId){
    PostPo[] ps:=c.ret{
      PostPo{author=userId}.select
    }
    return ps.map{fromPo(it)}
  }
  
  internal static Post create(Str userId,Str text){
    p:=c.ret{
      PostPo{author=userId;it.text=text;dt=DateTime.now;point=0}.insert
    }
    return fromPo(p)
  }
  
  static Post get(Int id){
    p:=c.ret{
      c.findById(PostPo#,id)
    }
    return fromPo(p)
  }
}
