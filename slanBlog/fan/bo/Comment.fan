//
// Copyright (c) 2010 Yang Jiandong
// Licensed under Eclipse Public License version 1.0
//
// History:
//   yangjiandong 2010-10-3 - Initial Contribution
//


**
**
**
class Comment:MyContext
{
  Int id
  Int owner
  Str author
  Str text
  new make(|This| f){ f(this) }
  
  static Comment? fromPo(CommentPo? p){
    if(p==null)return null
    return Comment{id=p.id;text=p.text;owner=p.owner;author=p.author}
  }
  
  internal Void delete(){
    c.use{
      CommentPo{it.id=this.id}.delete
    }
  }
  
  ////////////////////////////////////////////////////////////////////////
  //static
  ////////////////////////////////////////////////////////////////////////

  static Comment create(Int postId,Str author,Str text){
    p:=c.ret{
      CommentPo{it.owner=postId;it.author=author;it.text=text;dt=DateTime.now}.insert
    }
    return fromPo(p)
  }
  
  internal static Comment[] list(Int postId){
    CommentPo[] ps:=c.ret{
      CommentPo{it.owner=postId}.select
    }
    return ps.map{fromPo(it)}
  }
  
  static Comment get(Int id){
    p:=c.ret{
      c.findById(CommentPo#,id)
    }
    return fromPo(p)
  }
}
