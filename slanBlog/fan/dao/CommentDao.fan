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
  static Comment? fromPo(CommentPo? p){
    if(p==null)return null
    return Comment{id=p.id;text=p.text;owner=p.owner;author=p.author}
  }
  
  static Comment create(Int postId,Str author,Str text){
    p:=CommentPo{it.owner=postId;it.author=author;it.text=text;dt=DateTime.now}.insert
    return fromPo(p)
  }
  
  static Comment[] list(Int postId){
    CommentPo[] ps:= CommentPo{it.owner=postId}.select
    return ps.map{fromPo(it)}
  }
  
  static Comment get(Int id){
    p:= c.findById(CommentPo#,id)
    return fromPo(p)
  }
  
  static Void delete(Int id){
    CommentPo{it.id=id}.delete
  }
}
