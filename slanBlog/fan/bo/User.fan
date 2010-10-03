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
class User : MyContext
{
  Str id
  Role role
  new make(|This| f){ f(this) }
  
  static User? fromPo(UserPo? p){
    if(p==null)return null
    return User{id=p.id;role=p.role}
  }
  
  Post[] postList(){
    return Post.list(id)
  }
  
  Post createPost(Str text){
    return Post.create(id,text)
  }
  
  Bool deleteComment(Int commentId){
    c:= Comment.get(commentId)
    
    //I'm admin
    if(role==Role.admin){
      c.delete()
      return true
    }
    
    //I'm author
    if(c.author==id){
      c.delete()
      return true
    }
    
    //my post
    p:=Post.get(c.owner)
    if(p.author==id){
      c.delete()
      return true
    }
    
    return false
  }
  
  ////////////////////////////////////////////////////////////////////////
  //static
  ////////////////////////////////////////////////////////////////////////

  static User? login(Str id,Str password){
    up:=c.ret{
      UserPo{it.id=id;it.password=password}.one
    }
    return fromPo(up)
  }
  
  static User? logup(Str id,Str password,Str email){
    UserPo? p
    c.use{
      if(!UserPo{it.id=id}.exist){
        p=UserPo{
          it.id=id
          it.password=password
          it.email=email
          it.role=Role.normal
        }.insert
      }
    }
    return fromPo(p)
  }
  
  static User[] list(Int page){
    UserPo[] ps:=c.ret{
      UserPo{}.select
    }
    return ps.map{fromPo(it)}
  }
  
  static User get(Str id){
    p:=c.ret{
      c.findById(UserPo#,id)
    }
    return fromPo(p)
  }
}
