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
class Comment:CommentDao
{
  Int id
  Int owner
  Str author
  Str text
  new make(|This| f){ f(this) }
  
  Void deleteMe(){
    delete(id)
  }
}
