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
@Serializable
class User : MyRecord,UserDao
{
  @Id Str? id
  Str? password
  Str? name
  Str? email
  Date? birthday
  Role? role
  
  Bool deleteComment(Int commentId){
    c:= CommentDao.get(commentId)
    
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
    p:=PostDao.get(c.owner)
    if(p.author==id){
      c.delete()
      return true
    }
    
    return false
  }
}
