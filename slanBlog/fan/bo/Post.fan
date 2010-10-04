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
class Post : PostDao
{
  Int id
  Str text
  Str author
  DateTime dt
  new make(|This| f){ f(this) }
  
  Comment[] commentList(){
    Comment.list(id)
  }
  
  Void deleteMe(){
    delete(id)
    commentList.each{it.deleteMe}
  }
}
