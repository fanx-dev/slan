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
@Persistent
@Serializable
class Post : MyRecord,PostDao
{
  @Id{auto=true} Int? id
  Str? author
  DateTime? dt
  
  @Colu{m=1000} Str? text
  Int? point
  
  Comment[] commentList(){
    CommentDao.list(id)
  }
  
  Void deleteMe(){
    delete()
    commentList.each{it.delete}
  }
}
